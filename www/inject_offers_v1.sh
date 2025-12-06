#!/data/data/com.termux/files/usr/bin/bash
set -e

TS="$(date +%Y%m%d_%H%M%S)"

backup_file() {
  local f="$1"
  [ -f "$f" ] || return 0
  cp "$f" "$f.bak_${TS}"
}

inject_block_before_body_end() {
  local file="$1"
  local block="$2"
  grep -q "UVQDS_OFFERS_INJECTED_V1" "$file" && return 0

  # If </body> exists, inject before it. Otherwise append.
  if grep -qi "</body>" "$file"; then
    awk -v blk="$block" '
      BEGIN{IGNORECASE=1}
      /<\/body>/ && !done { print blk; done=1 }
      { print }
    ' "$file" > "${file}.tmp"
    mv "${file}.tmp" "$file"
  else
    printf "\n%s\n" "$block" >> "$file"
  fi
}

# ---- Offer blocks (safe, small, self-contained) ----
OFFERS_SECTION='
<!-- UVQDS_OFFERS_INJECTED_V1 -->
<section style="margin:18px 0;padding:16px;border-radius:18px;
background:linear-gradient(180deg, rgba(255,255,255,.03), transparent 35%), #0e111b;
border:1px solid rgba(255,255,255,.06);
box-shadow:0 10px 40px rgba(0,0,0,.55), inset 0 0 0 1px rgba(255,255,255,.04);">
  <div style="display:inline-flex;gap:8px;align-items:center;
  padding:6px 10px;border-radius:999px;
  background:linear-gradient(90deg, rgba(167,139,250,.18), rgba(34,211,238,.14));
  border:1px solid rgba(255,255,255,.06);color:#a7acc7;font-size:11px;">
    Offers • Productised • Fast decisions
  </div>
  <h2 style="margin:10px 0 6px;font-size:22px;color:#eef1ff;">The “Hard to Refuse” Stack</h2>
  <div style="color:#a7acc7;font-size:13px;line-height:1.45;">
    Three clean packages built for rapid clarity: microsite, showcase hub, or demo suite.
  </div>
  <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:12px;">
    <a href="offer_index_v1.html" style="text-decoration:none;color:#eef1ff;
    padding:10px 12px;border-radius:12px;
    background:linear-gradient(90deg, rgba(167,139,250,.18), rgba(34,211,238,.12));
    border:1px solid rgba(255,255,255,.08);">Open Offers Index →</a>
    <span style="color:#a7acc7;font-size:11px;align-self:center;">
      Local: 127.0.0.1:8000/offer_index_v1.html
    </span>
  </div>
</section>
'

HOME_OFFERS_BUTTON='
<!-- UVQDS_OFFERS_BTN_V1 -->
<div style="margin-top:10px;">
  <a href="offer_index_v1.html" style="display:inline-flex;align-items:center;
  gap:8px;text-decoration:none;color:#eef1ff;
  padding:10px 12px;border-radius:12px;
  background:linear-gradient(90deg, rgba(167,139,250,.18), rgba(34,211,238,.12));
  border:1px solid rgba(255,255,255,.08);">
    💼 Offers
  </a>
</div>
'

# ---- Choose portfolio target ----
PORT=""
for cand in portfolio_market_allinone_v1.html portfolio_v1.html portfolio.html; do
  if [ -f "$cand" ]; then PORT="$cand"; break; fi
done

# ---- Inject into portfolio ----
if [ -n "$PORT" ]; then
  backup_file "$PORT"
  inject_block_before_body_end "$PORT" "$OFFERS_SECTION"
  echo "✅ Injected offers section into: $PORT"
else
  echo "⚠️ No portfolio file found (portfolio_v1.html / portfolio.html). Skipping portfolio injection."
fi

# ---- Inject into home index ----
if [ -f "index.html" ]; then
  backup_file "index.html"
  # Add button block near end if not already present
  grep -q "UVQDS_OFFERS_BTN_V1" index.html || {
    # Try to insert before </body>
    if grep -qi "</body>" index.html; then
      awk -v blk="$HOME_OFFERS_BUTTON" '
        BEGIN{IGNORECASE=1}
        /<\/body>/ && !done { print blk; done=1 }
        { print }
      ' index.html > index.html.tmp
      mv index.html.tmp index.html
    else
      printf "\n%s\n" "$HOME_OFFERS_BUTTON" >> index.html
    fi
  }
  echo "✅ Added Offers button into: index.html"
else
  echo "⚠️ index.html not found. Skipping home injection."
fi

echo ""
echo "Done. Backups created with .bak_${TS}"
