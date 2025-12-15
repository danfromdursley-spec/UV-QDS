#!/data/data/com.termux/files/usr/bin/bash
set -e
ROOT="$HOME/OMEGA_EMPIRE/UV_QDS/www"
TS="$(date +%Y%m%d_%H%M%S)"

python - <<'PY'
import re, pathlib, datetime

root = pathlib.Path.home()/"OMEGA_EMPIRE/UV_QDS/www"
ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

# likely candidates
globs = [
  "physorg*triage*.html",
  "physorg*supervault*.html",
  "*news*triage*.html",
  "*triage*.html",
  "*supervault*.html",
]

files = []
seen=set()
for g in globs:
  for p in root.glob(g):
    if p.is_file() and p.suffix==".html" and p.name not in seen:
      seen.add(p.name)
      files.append(p)

if not files:
  print("[fix] no candidate vault html files found in:", root)
  raise SystemExit(0)

marker = "QDS_JSON_ROOT_FIX"

# pattern: const/let/var data = await something.json();
pat_decl = re.compile(r'(?m)^(?P<kw>const|let|var)\s+(?P<var>[A-Za-z_$][\w$]*)\s*=\s*await\s+(?P<resp>[A-Za-z_$][\w$]*)\.json\(\)\s*;\s*$')

# more generic: const data = await (await fetch(...)).json();
pat_decl_any = re.compile(r'(?m)^(?P<kw>const|let|var)\s+(?P<var>[A-Za-z_$][\w$]*)\s*=\s*(?P<rhs>await\s+.*?\.json\(\))\s*;\s*$')

# assignment without declaration: data = await res.json();
pat_asg = re.compile(r'(?m)^(?P<var>[A-Za-z_$][\w$]*)\s*=\s*await\s+(?P<resp>[A-Za-z_$][\w$]*)\.json\(\)\s*;\s*$')

patched = 0
for p in files:
  s = p.read_text(errors="ignore")
  if marker in s:
    print(f"[skip] {p.name} already patched")
    continue

  orig = s

  def repl_decl(m):
    kw, var, resp = m.group("kw","var","resp")
    raw = f"__qds_raw_{var}"
    return (
      f"{kw} {raw} = await {resp}.json();\n"
      f"{kw} {var} = Array.isArray({raw}) ? {{items: {raw}, entries: {raw}}} : {raw}; // {marker}"
    )

  s2 = pat_decl.sub(repl_decl, s)

  if s2 == s:
    # try generic decl
    def repl_decl_any(m):
      kw, var, rhs = m.group("kw","var","rhs")
      raw = f"__qds_raw_{var}"
      return (
        f"{kw} {raw} = {rhs};\n"
        f"{kw} {var} = Array.isArray({raw}) ? {{items: {raw}, entries: {raw}}} : {raw}; // {marker}"
      )
    s2 = pat_decl_any.sub(repl_decl_any, s)

  if s2 == s:
    # try assignment-only
    def repl_asg(m):
      var, resp = m.group("var","resp")
      raw = f"__qds_raw_{var}"
      return (
        f"const {raw} = await {resp}.json();\n"
        f"{var} = Array.isArray({raw}) ? {{items: {raw}, entries: {raw}}} : {raw}; // {marker}"
      )
    s2 = pat_asg.sub(repl_asg, s)

  if s2 == orig:
    print(f"[nope] {p.name} (no .json() assignment pattern found)")
    continue

  # backup + write
  bak = p.with_name(p.name + f".bak_fix_{ts}")
  bak.write_text(orig)
  p.write_text(s2)
  print(f"[ok ] patched {p.name}  (backup: {bak.name})")
  patched += 1

print(f"[done] patched files: {patched}")
PY
