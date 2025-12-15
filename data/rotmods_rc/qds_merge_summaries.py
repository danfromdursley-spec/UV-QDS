#!/usr/bin/env python3
# qds_merge_summaries.py
# Merge multiple SUMMARY_qds_fit.csv (or augmented variants) into:
#  - SUMMARY_mega_all.csv (all rows + run_id + computed AICc/BIC + clipped improvements)
#  - SUMMARY_mega_best.csv (best row per galaxy by chosen criterion)
#
# Termux/phone-safe. No deps.

import os, sys, csv, math, argparse

def norm(s):
    return (s or "").strip().lower()

def pick_key(fieldnames, wants):
    """Pick the first field whose normalized name matches any of 'wants' (exact or contains)."""
    fns = list(fieldnames or [])
    nf = [norm(x) for x in fns]
    for w in wants:
        w = norm(w)
        # exact
        if w in nf:
            return fns[nf.index(w)]
        # contains
        for i, x in enumerate(nf):
            if w in x:
                return fns[i]
    return None

def ffloat(x, default=None):
    try:
        if x is None: return default
        s = str(x).strip()
        if s == "": return default
        return float(s)
    except Exception:
        return default

def aicc(chi2, k, n):
    # AIC = chi2 + 2k, AICc = AIC + (2k(k+1))/(n-k-1) when defined
    AIC = chi2 + 2.0*k
    if n is None or n <= (k + 1):
        return AIC
    denom = (n - k - 1.0)
    if denom <= 0:
        return AIC
    return AIC + (2.0*k*(k+1.0))/denom

def bic(chi2, k, n):
    if n is None or n <= 0:
        return chi2 + k*2.0  # fallback-ish
    return chi2 + k*math.log(float(n))

def run_id_from_path(p):
    # Nice run id = parent folder name if it looks like qds_fit_out_..., else file stem
    p = os.path.abspath(p)
    parent = os.path.basename(os.path.dirname(p))
    base = os.path.basename(p)
    stem = os.path.splitext(base)[0]
    if parent and parent.startswith("qds_fit_out_"):
        return parent
    return stem

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+", help="SUMMARY_qds_fit.csv files (one or many)")
    ap.add_argument("--out-all", default="SUMMARY_mega_all.csv", help="output merged-all CSV")
    ap.add_argument("--out-best", default="SUMMARY_mega_best.csv", help="output best-per-galaxy CSV")
    ap.add_argument("--criterion", default="aicc", choices=["aicc","bic","chi2_qds","redchi2_qds"], help="best selection criterion")
    ap.add_argument("--kq", type=int, default=2, help="QDS parameter count for info criteria (default 2: v0, lam)")
    ap.add_argument("--kb", type=int, default=0, help="Bary parameter count for info criteria (default 0)")
    args = ap.parse_args()

    rows = []
    bad = 0

    for fp in args.files:
        if not os.path.isfile(fp):
            print(f"[skip] not a file: {fp}", file=sys.stderr)
            continue
        rid = run_id_from_path(fp)
        with open(fp, "r", newline="") as f:
            r = csv.DictReader(f)
            if not r.fieldnames:
                print(f"[skip] no header: {fp}", file=sys.stderr)
                continue

            # map keys (robust to name variants)
            k_gal = pick_key(r.fieldnames, ["galaxy","name"])
            k_n   = pick_key(r.fieldnames, ["npts","n","n_points","npoints"])
            k_cb  = pick_key(r.fieldnames, ["chi2_bary","chi2_b","chisq_bary","chisq_b"])
            k_rb  = pick_key(r.fieldnames, ["redchi2_bary","redchi2_b","red_chi2_bary","rchib"])
            k_cq  = pick_key(r.fieldnames, ["chi2_qds","chi2_q","chisq_qds","chisq_q"])
            k_rq  = pick_key(r.fieldnames, ["redchi2_qds","redchi2_q","red_chi2_qds","rchiq"])
            k_v0  = pick_key(r.fieldnames, ["v0","v_0"])
            k_lam = pick_key(r.fieldnames, ["lam","lambda","lam_kpc","lambda_kpc"])

            for line in r:
                gal = (line.get(k_gal) if k_gal else None)
                gal = (gal or "").strip()
                if not gal:
                    bad += 1
                    continue

                npts = ffloat(line.get(k_n), None) if k_n else None
                cb   = ffloat(line.get(k_cb), None) if k_cb else None
                rb   = ffloat(line.get(k_rb), None) if k_rb else None
                cq   = ffloat(line.get(k_cq), None) if k_cq else None
                rq   = ffloat(line.get(k_rq), None) if k_rq else None
                v0   = ffloat(line.get(k_v0), None) if k_v0 else None
                lam  = ffloat(line.get(k_lam), None) if k_lam else None

                # compute improvements safely
                imp_chi2 = 0.0
                if cb and cb > 0 and cq is not None:
                    imp_chi2 = 100.0*(cb - cq)/cb
                if imp_chi2 < 0: imp_chi2 = 0.0

                imp_rchi2 = 0.0
                if rb and rb > 0 and rq is not None:
                    imp_rchi2 = 100.0*(rb - rq)/rb
                if imp_rchi2 < 0: imp_rchi2 = 0.0

                # info criteria
                _n = int(npts) if npts is not None else None
                _cb = cb if cb is not None else (rb*_n if (rb is not None and _n) else None)
                _cq = cq if cq is not None else (rq*_n if (rq is not None and _n) else None)

                aiccb = aicc(_cb, args.kb, _n) if _cb is not None else None
                aiccq = aicc(_cq, args.kq, _n) if _cq is not None else None
                bicb  = bic(_cb, args.kb, _n)  if _cb is not None else None
                bicq  = bic(_cq, args.kq, _n)  if _cq is not None else None

                row = dict(line)  # preserve originals
                row.update({
                    "run_id": rid,
                    "galaxy": gal,
                    "npts": "" if npts is None else int(npts),
                    "chi2_bary": "" if cb is None else cb,
                    "redchi2_bary": "" if rb is None else rb,
                    "chi2_qds": "" if cq is None else cq,
                    "redchi2_qds": "" if rq is None else rq,
                    "v0": "" if v0 is None else v0,
                    "lam": "" if lam is None else lam,
                    "imp_chi2_clip0": imp_chi2,
                    "imp_redchi2_clip0": imp_rchi2,
                    "AICc_bary": "" if aiccb is None else aiccb,
                    "AICc_qds": "" if aiccq is None else aiccq,
                    "BIC_bary": "" if bicb is None else bicb,
                    "BIC_qds": "" if bicq is None else bicq,
                    "AICc_win": (1 if (aiccb is not None and aiccq is not None and aiccq < aiccb) else 0),
                    "BIC_win":  (1 if (bicb  is not None and bicq  is not None and bicq  < bicb ) else 0),
                })
                rows.append(row)

    if not rows:
        print("No rows loaded.", file=sys.stderr)
        return 2

    # decide best row per galaxy
    def crit_val(r):
        c = args.criterion
        if c == "aicc":
            v = ffloat(r.get("AICc_qds"), None)
            return v if v is not None else float("inf")
        if c == "bic":
            v = ffloat(r.get("BIC_qds"), None)
            return v if v is not None else float("inf")
        if c == "chi2_qds":
            v = ffloat(r.get("chi2_qds"), None)
            return v if v is not None else float("inf")
        if c == "redchi2_qds":
            v = ffloat(r.get("redchi2_qds"), None)
            return v if v is not None else float("inf")
        return float("inf")

    best = {}
    for r in rows:
        g = r.get("galaxy","").strip()
        if not g: continue
        v = crit_val(r)
        if g not in best or v < crit_val(best[g]):
            best[g] = r

    # output columns: prefer a clean, stable set first
    core_cols = [
        "run_id","galaxy","npts",
        "chi2_bary","chi2_qds","redchi2_bary","redchi2_qds",
        "imp_chi2_clip0","imp_redchi2_clip0",
        "v0","lam",
        "AICc_bary","AICc_qds","AICc_win",
        "BIC_bary","BIC_qds","BIC_win",
    ]
    # then any extras from originals (but avoid duplicates)
    extra_cols = []
    seen = set(core_cols)
    for r in rows:
        for k in r.keys():
            if k not in seen:
                extra_cols.append(k); seen.add(k)
        break

    cols = core_cols + extra_cols

    def write_csv(path, data):
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        with open(path, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=cols, extrasaction="ignore")
            w.writeheader()
            for r in data:
                w.writerow(r)

    out_all = args.out_all
    out_best = args.out_best

    write_csv(out_all, rows)
    write_csv(out_best, [best[g] for g in sorted(best.keys())])

    # quick stats
    n = len(rows)
    nbest = len(best)
    chi2_wins = sum(1 for r in best.values() if ffloat(r.get("chi2_qds"),1e99) < ffloat(r.get("chi2_bary"),1e99))
    aicc_wins = sum(int(ffloat(r.get("AICc_win"),0) or 0) for r in best.values())
    bic_wins  = sum(int(ffloat(r.get("BIC_win"),0) or 0) for r in best.values())
    mean_imp  = sum(ffloat(r.get("imp_chi2_clip0"),0) or 0 for r in best.values()) / (nbest or 1)

    print("OK")
    print("loaded_rows:", n, " bad_rows:", bad)
    print("unique_galaxies(best):", nbest, " criterion:", args.criterion)
    print("BEST chi2_wins:", chi2_wins, " frac:", (chi2_wins/(nbest or 1)))
    print("BEST AICc_wins:", aicc_wins, " frac:", (aicc_wins/(nbest or 1)))
    print("BEST BIC_wins :", bic_wins,  " frac:", (bic_wins/(nbest or 1)))
    print("BEST mean_imp_chi2_clip0:", mean_imp)
    print("out_all :", os.path.abspath(out_all))
    print("out_best:", os.path.abspath(out_best))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
