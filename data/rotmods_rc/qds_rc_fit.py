#!/usr/bin/env python3
# QDS Rotation Curve fitter (SPARC rotmod CSVs)
# - stdlib only (Termux safe)
# - supports single file or directory batch
# - lam grid uses geomspace + auto-expand when boundary hit
# - outputs per-galaxy bestfit CSV + SUMMARY_qds_fit.csv

import os, sys, csv, math, time, argparse
from datetime import datetime

# ----------------------------- utils -----------------------------

def geomspace(a, b, n):
    """Geometric spacing inclusive endpoints."""
    if n <= 1:
        return [float(a)]
    a = float(a); b = float(b)
    if a <= 0 or b <= 0:
        raise ValueError("geomspace requires positive a,b")
    r = (b / a) ** (1.0 / (n - 1))
    return [a * (r ** i) for i in range(n)]

def linspace(a, b, n):
    if n <= 1:
        return [float(a)]
    a = float(a); b = float(b)
    step = (b - a) / (n - 1)
    return [a + i * step for i in range(n)]

def ffloat(x, default=None):
    try:
        return float(x)
    except Exception:
        return default

def clamp_pos(x, eps=1e-12):
    return x if x > eps else eps

def sanitize_name(name):
    # keep it file-safe
    out = []
    for ch in name:
        if ch.isalnum() or ch in "._-":
            out.append(ch)
        else:
            out.append("_")
    return "".join(out)

def v_bary(vgas, vdisk, vbul):
    # allow small negatives in components; squares handle it
    return math.sqrt((vgas or 0.0)**2 + (vdisk or 0.0)**2 + (vbul or 0.0)**2)

# --------------------------- models -----------------------------

def model_flatboost(r, vb, v0, lam):
    # V = sqrt(Vb^2 + (V0*(1-exp(-r/lam)))^2)
    lam = clamp_pos(lam)
    t = 1.0 - math.exp(-r / lam)
    return math.sqrt(vb*vb + (v0*t)*(v0*t))

def model_gaussboost(r, vb, v0, lam):
    # V = sqrt(Vb^2 + (V0*(1-exp(-r^2/(2 lam^2))))^2)
    lam = clamp_pos(lam)
    t = 1.0 - math.exp(-(r*r) / (2.0*lam*lam))
    return math.sqrt(vb*vb + (v0*t)*(v0*t))

MODEL_MAP = {
    "flatboost": model_flatboost,
    "gaussboost": model_gaussboost,
}

# ------------------------ IO / parsing --------------------------

def read_rotmod_csv(path):
    """
    Expect header:
    r_kpc,Vobs,err,Vgas,Vdisk,Vbul
    """
    rows = []
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        r = csv.reader(f)
        header = next(r, None)
        if not header:
            return rows

        # allow any header order as long as we can find the keys
        h = [x.strip() for x in header]
        idx = {name: i for i, name in enumerate(h)}

        def get(name, fallback=None):
            return idx.get(name, fallback)

        ir = get("r_kpc", 0)
        iv = get("Vobs", 1)
        ie = get("err", 2)
        ig = get("Vgas", 3)
        idk = get("Vdisk", 4)
        ibu = get("Vbul", 5)

        for line in r:
            if not line:
                continue
            rr = ffloat(line[ir], None) if ir < len(line) else None
            vv = ffloat(line[iv], None) if iv < len(line) else None
            ee = ffloat(line[ie], None) if ie < len(line) else None

            if rr is None or vv is None or ee is None:
                continue

            vg = ffloat(line[ig], 0.0) if ig is not None and ig < len(line) else 0.0
            vd = ffloat(line[idk], 0.0) if idk is not None and idk < len(line) else 0.0
            vb = ffloat(line[ibu], 0.0) if ibu is not None and ibu < len(line) else 0.0

            rows.append((rr, vv, ee, vg, vd, vb))

    return rows

# ------------------------- scoring ------------------------------

def chi2_for_params(rows, model_fn, v0, lam):
    chi2 = 0.0
    for (r, vobs, verr, vgas, vdisk, vbul) in rows:
        vb = v_bary(vgas, vdisk, vbul)
        vm = model_fn(clamp_pos(r), vb, v0, lam)
        e = clamp_pos(abs(verr))
        res = (vobs - vm) / e
        chi2 += res * res
    return chi2

def redchi2(chi2, npts, kparams):
    dof = npts - kparams
    if dof <= 0:
        return float("nan")
    return chi2 / dof

# --------------------- grid building ----------------------------

DEFAULT_LAM_MIN = 0.02
DEFAULT_LAM_MAX = 200.0

def build_lam_grid(fast=False, lam_min=DEFAULT_LAM_MIN, lam_max=DEFAULT_LAM_MAX):
    # geometric grid gives your "fingerprint" values but with sane bounds
    if fast:
        return geomspace(lam_min, lam_max, 13)
    else:
        return geomspace(lam_min, lam_max, 31)

def build_v0_grid(v0_max, fast=False):
    # linear grid is fine (v0 behaves smoother than lam)
    if fast:
        return linspace(0.0, v0_max, 41)
    else:
        return linspace(0.0, v0_max, 121)

def estimate_v0_max(rows):
    # crude but robust: scale to observed peak
    vmax = 0.0
    for (_, vobs, _, _, _, _) in rows:
        if vobs is not None:
            vmax = max(vmax, float(vobs))
    # give headroom
    return max(50.0, 2.0 * vmax + 50.0)

# --------------------- fitting logic ----------------------------

def grid_search(rows, model_fn, fast=False,
                lam_min=DEFAULT_LAM_MIN, lam_max=DEFAULT_LAM_MAX,
                v0_max=None, auto_expand=True, max_expands=2):
    npts = len(rows)
    if npts == 0:
        return None

    if v0_max is None:
        v0_max = estimate_v0_max(rows)

    # initial grids
    lam_grid = build_lam_grid(fast=fast, lam_min=lam_min, lam_max=lam_max)
    v0_grid = build_v0_grid(v0_max=v0_max, fast=fast)

    best = None  # (chi2, v0, lam)

    def scan(lam_grid_local, v0_grid_local):
        nonlocal best
        best = None
        for lam in lam_grid_local:
            for v0 in v0_grid_local:
                c2 = chi2_for_params(rows, model_fn, v0, lam)
                if (best is None) or (c2 < best[0]):
                    best = (c2, v0, lam)

    scan(lam_grid, v0_grid)

    if not auto_expand:
        return best

    # auto-expand if boundary hit (grid-wall breaker)
    expands = 0
    while expands < max_expands:
        if best is None:
            break

        _, bv0, blam = best
        lam_lo = min(lam_grid)
        lam_hi = max(lam_grid)

        hit_lo = (blam <= lam_lo * 1.0000001)
        hit_hi = (blam >= lam_hi * 0.9999999)

        if not (hit_lo or hit_hi):
            break

        # expand range
        new_min = max(0.005, lam_lo / 4.0)
        new_max = min(5000.0, lam_hi * 4.0)

        lam_grid = build_lam_grid(fast=fast, lam_min=new_min, lam_max=new_max)

        # keep v0 grid same; could expand v0 too but usually lam is the culprit
        scan(lam_grid, v0_grid)
        expands += 1

    return best

# ------------------------ output CSV ----------------------------

OUT_HEADER = [
    "r_kpc","vobs","verr","vgas","vdisk","vbul",
    "v_bary","v_qds_component","v_model",
    "res_bary","res_qds",
    "res_bary_norm","res_qds_norm"
]

def write_bestfit_csv(out_path, rows, model_fn, v0, lam):
    with open(out_path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(OUT_HEADER)

        for (r, vobs, verr, vgas, vdisk, vbul) in rows:
            vb = v_bary(vgas, vdisk, vbul)
            rpos = clamp_pos(r)
            vm = model_fn(rpos, vb, v0, lam)

            # component = extra above bary, in quadrature
            vq = vm*vm - vb*vb
            vq = math.sqrt(vq) if vq > 0 else 0.0

            rb = vobs - vb
            rq = vobs - vm

            e = clamp_pos(abs(verr))
            w.writerow([
                r, vobs, verr, vgas, vdisk, vbul,
                vb, vq, vm,
                rb, rq,
                rb / e, rq / e
            ])

# ------------------------- runner -------------------------------

def ts_stamp():
    return datetime.utcnow().strftime("%Y%m%d_%H%M%S")

def fmt_num(x, sig=6):
    try:
        if x is None or (isinstance(x, float) and (math.isnan(x) or math.isinf(x))):
            return "NA"
        # pretty compact
        return f"{float(x):.{sig}g}"
    except Exception:
        return "NA"

def process_one(csv_path, args, outdir):
    base = os.path.splitext(os.path.basename(csv_path))[0]
    gal = sanitize_name(base)

    rows = read_rotmod_csv(csv_path)
    npts = len(rows)
    if npts < 3:
        return {
            "galaxy": gal, "n": npts,
            "chi2_bary": float("nan"), "redchi2_bary": float("nan"),
            "chi2_qds": float("nan"), "redchi2_qds": float("nan"),
            "improve_pct": 0.0, "v0": 0.0, "lam": DEFAULT_LAM_MIN,
            "out_csv": ""
        }

    model_fn = MODEL_MAP[args.model]

    # baseline bary-only chi2: model is vb (i.e. v0=0 effectively, but compare to vb not to model_fn)
    chi2_b = 0.0
    for (r, vobs, verr, vgas, vdisk, vbul) in rows:
        vb = v_bary(vgas, vdisk, vbul)
        e = clamp_pos(abs(verr))
        res = (vobs - vb) / e
        chi2_b += res * res

    rb = redchi2(chi2_b, npts, kparams=0)

    # qds fit
    v0_max = args.v0_max
    lam_min = args.lam_min
    lam_max = args.lam_max

    best = grid_search(
        rows, model_fn,
        fast=args.fast,
        lam_min=lam_min, lam_max=lam_max,
        v0_max=v0_max,
        auto_expand=(not args.no_auto_expand),
        max_expands=args.max_expands
    )

    if best is None:
        chi2_q = float("nan"); rq = float("nan"); bv0 = 0.0; blam = lam_min
    else:
        chi2_q, bv0, blam = best
        rq = redchi2(chi2_q, npts, kparams=2)

    improve = 0.0
    if chi2_b > 0 and not (math.isnan(chi2_q) or math.isinf(chi2_q)):
        improve = 100.0 * (chi2_b - chi2_q) / chi2_b

    out_csv = os.path.join(outdir, f"{gal}_QDS_bestfit.csv")
    write_bestfit_csv(out_csv, rows, model_fn, bv0, blam)

    return {
        "galaxy": gal, "n": npts,
        "chi2_bary": chi2_b, "redchi2_bary": rb,
        "chi2_qds": chi2_q, "redchi2_qds": rq,
        "improve_pct": improve,
        "v0": bv0, "lam": blam,
        "out_csv": out_csv
    }

def main():
    ap = argparse.ArgumentParser(description="QDS RC fit (flatboost/gaussboost) on SPARC rotmod CSVs")
    ap.add_argument("input", help="CSV file or directory of CSVs")
    ap.add_argument("--model", choices=sorted(MODEL_MAP.keys()), default="flatboost", help="Model family")
    ap.add_argument("--fast", action="store_true", help="Use coarse grids (faster)")
    ap.add_argument("--outdir", default="", help="Output directory (default auto-named in CWD)")
    ap.add_argument("--lam-min", type=float, default=DEFAULT_LAM_MIN, help="Lambda minimum for grid (default 0.02)")
    ap.add_argument("--lam-max", type=float, default=DEFAULT_LAM_MAX, help="Lambda maximum for grid (default 200)")
    ap.add_argument("--v0-max", type=float, default=None, help="V0 maximum for grid (default auto from data)")
    ap.add_argument("--no-auto-expand", action="store_true", help="Disable auto expanding lambda range on boundary hits")
    ap.add_argument("--max-expands", type=int, default=2, help="Max lambda expansions (default 2)")
    args = ap.parse_args()

    inp = args.input
    if not os.path.exists(inp):
        print("❌ input not found:", inp)
        return 2

    # output dir
    if args.outdir:
        outdir = args.outdir
    else:
        outdir = os.path.join(os.getcwd(), f"qds_fit_out_{args.model}_{ts_stamp()}")
    os.makedirs(outdir, exist_ok=True)

    # gather files
    files = []
    if os.path.isdir(inp):
        for name in sorted(os.listdir(inp)):
            if name.lower().endswith(".csv"):
                files.append(os.path.join(inp, name))
    else:
        files = [inp]

    # run
    results = []
    if len(files) == 1 and not os.path.isdir(inp):
        res = process_one(files[0], args, outdir)
        results.append(res)

        print("✅ DONE")
        print("galaxy:", res["galaxy"])
        print("n:", res["n"])
        print("bary:  redχ²=" + fmt_num(res["redchi2_bary"], 6))
        print("qds :  redχ²=" + fmt_num(res["redchi2_qds"], 6),
              " improve=" + (f"{res['improve_pct']:+.2f}%"))
        print("best params: v0=" + fmt_num(res["v0"], 6), " lam=" + fmt_num(res["lam"], 6))
        print("out:", res["out_csv"])
        print("outdir:", outdir)

    else:
        # batch mode
        for f in files:
            gal = sanitize_name(os.path.splitext(os.path.basename(f))[0])
            res = process_one(f, args, outdir)
            results.append(res)

            # compact line
            rb = res["redchi2_bary"]; rq = res["redchi2_qds"]
            imp = res["improve_pct"]
            print(f"✅ {gal}: redχ² bary={fmt_num(rb,6)} → qds={fmt_num(rq,6)}  ({imp:+.1f}%)  v0={fmt_num(res['v0'],5)} lam={fmt_num(res['lam'],5)}")

        print("\n🔥 BATCH DONE")
        print("outdir:", outdir)

    # write summary
    summ = os.path.join(outdir, "SUMMARY_qds_fit.csv")
    with open(summ, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["galaxy","n","chi2_bary","redchi2_bary","chi2_qds","redchi2_qds","improve_pct","v0","lam","out_csv"])
        for r in results:
            w.writerow([
                r["galaxy"], r["n"],
                r["chi2_bary"], r["redchi2_bary"],
                r["chi2_qds"], r["redchi2_qds"],
                r["improve_pct"], r["v0"], r["lam"],
                r["out_csv"]
            ])

    print("summary:", summ)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
