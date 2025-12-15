#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
TS=$(date +%Y%m%d_%H%M%S)

FILES=(
  physorg_news_dashboard.html
  physorg_qds_triage.html
  physorg_supervault.html
  physorg_supervault_v4.html
  qds_battery_news_lab_v1.html
)

for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  cp -f "$f" "$f.bak_fixlinks_$TS"

  # Inject normaliser once per file (right after </style><script...>)
  if ! grep -q "function normPhysUrl" "$f"; then
    perl -0777 -i -pe 's@(</style>\s*<script[^>]*>)@$1\n\nfunction normPhysUrl(u){\n  u=(u||\"\").toString().trim();\n  if(!u) return \"\";\n  const m=u.match(/(https?:\\/\\/)?(www\\.)?phys\\.org\\/news\\/[^\s\"\\x27<>]+/i);\n  if(m){\n    let s=m[0].replace(/^\\/\\//, \"\");\n    if(!/^https?:\\/\\//i.test(s)) s=\"https://\"+s.replace(/^www\\./i, \"\");\n    return s;\n  }\n  if(u.startsWith(\"//\")) return \"https:\"+u;\n  if(/^https?:\\/\\//i.test(u)) return u;\n  if(u.startsWith(\"www.\")) return \"https://\"+u;\n  if(/^phys\\.org/i.test(u)) return \"https://\"+u;\n  if(u.startsWith(\"/\")) return \"https://phys.org\"+u;\n  return \"https://phys.org/\"+u.replace(/^\\/+/, \"\");\n}\nfunction normMaybePhys(u){\n  u=(u||\"\").toString().trim();\n  if(!u) return \"\";\n  return (/phys\\.org/i.test(u) || /\\/news\\//i.test(u)) ? normPhysUrl(u) : u;\n}\n\n@sm' "$f"
  fi

  # Harden common open pattern: window.open(url, "_blank");
  perl -0777 -i -pe 's@window\\.open\\(([^,]+),\\s*\"_blank\"\\s*\\);@window.open(normMaybePhys($1), \"_blank\", \"noopener,noreferrer\");@gms' "$f"

  # Harden common link assignment: const link = it.link || "#";
  perl -0777 -i -pe 's@const\\s+link\\s*=\\s*it\\.link\\s*\\|\\|\\s*\"#\";@const link = normPhysUrl(it.link) || \"#\";@gms' "$f"
done

echo "[qds] link fix done. backups created: *.bak_fixlinks_$TS"
