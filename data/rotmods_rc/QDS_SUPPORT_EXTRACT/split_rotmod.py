import re, os, sys

src = "rotmod.dat"
outdir = "rotmod_split"
os.makedirs(outdir, exist_ok=True)

def is_num(s):
    try:
        float(s)
        return True
    except:
        return False

gal = None
fh = None
wrote_header = False

def open_new(name):
    global gal, fh, wrote_header
    if fh:
        fh.close()
    gal = re.sub(r'[^A-Za-z0-9_\-]+', '_', name.strip())
    path = os.path.join(outdir, f"{gal}.csv")
    fh = open(path, "w", encoding="utf-8")
    fh.write("r_kpc,Vobs,err,Vgas,Vdisk,Vbul\n")
    wrote_header = True

with open(src, "r", encoding="utf-8", errors="ignore") as f:
    for line in f:
        s = line.strip()
        if not s:
            continue

        # Galaxy block markers: common SPARC patterns
        if s.startswith("#") or s.startswith("!") or s.lower().startswith("galaxy"):
            # try to grab a name from the line
            name = s.lstrip("#!").strip()
            # if line contains something like "NGC3198" anywhere, prefer that
            m = re.search(r'\b([A-Z]{2,5}\s?\d{2,6}[A-Z]?)\b', name.replace(" ", ""))
            if m:
                open_new(m.group(1))
            else:
                # fallback: use whole marker line
                open_new(name[:60] if name else "UNKNOWN")
            continue

        parts = re.split(r'\s+', s)
        if len(parts) < 3:
            continue

        # numeric row: expect at least r, vobs, err (then optional gas/disk/bulge)
        if is_num(parts[0]) and is_num(parts[1]) and is_num(parts[2]):
            if gal is None:
                open_new("UNKNOWN")
            r = parts[0]
            vobs = parts[1]
            err = parts[2]
            vgas = parts[3] if len(parts) > 3 and is_num(parts[3]) else ""
            vdisk = parts[4] if len(parts) > 4 and is_num(parts[4]) else ""
            vbul = parts[5] if len(parts) > 5 and is_num(parts[5]) else ""
            fh.write(f"{r},{vobs},{err},{vgas},{vdisk},{vbul}\n")

if fh:
    fh.close()

print("✅ split written to:", outdir)
