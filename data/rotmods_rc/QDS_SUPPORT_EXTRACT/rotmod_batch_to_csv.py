import os, re, glob, csv

IN_DIR = "rotmod_LTG"
OUT_DIR = "rotmod_csv"
os.makedirs(OUT_DIR, exist_ok=True)

def isnum(x):
    try:
        float(x); return True
    except:
        return False

def sanitize(name):
    return re.sub(r'[^A-Za-z0-9_.-]+', '_', name)

# Heuristic: SPARC rotmod files are whitespace-delimited and usually have:
# r  Vobs  err  Vgas  Vdisk  Vbul  (sometimes more cols; we keep first 6 numeric)
header = ["r_kpc","Vobs","err","Vgas","Vdisk","Vbul"]

files = sorted(glob.glob(os.path.join(IN_DIR, "**", "*_rotmod.dat"), recursive=True))
print("Found:", len(files), "rotmod files")

written = 0
for path in files:
    base = os.path.basename(path).replace("_rotmod.dat","")
    gal = sanitize(base)
    out = os.path.join(OUT_DIR, f"{gal}.csv")

    rows = []
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            s = line.strip()
            if not s or s.startswith("#") or s.startswith("!") or s.lower().startswith("gal"):
                continue
            parts = re.split(r"\s+", s)
            nums = [p for p in parts if isnum(p)]
            if len(nums) >= 3:
                # take first 6 numeric fields if present
                nums = nums[:6] + [""]*(6-len(nums))
                rows.append(nums[:6])

    if rows:
        with open(out, "w", newline="", encoding="utf-8") as fo:
            w = csv.writer(fo)
            w.writerow(header)
            w.writerows(rows)
        written += 1

print("✅ wrote CSVs:", written, "in", OUT_DIR)
