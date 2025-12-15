#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

FILE="qds_test_platform.html"
BACKUP="${FILE%.html}_backup_$(date +%Y%m%d_%H%M%S).html"

echo "Backing up $FILE -> $BACKUP"
cp "$FILE" "$BACKUP"

awk '
/Open H0 Variance Lab/ {
  print "          <a class=\"btn-main\" href=\"qds_variance_lab.html\">Open H0 Variance Lab</a>";
  next
}
/Open Rotation Lab/ {
  print "          <a class=\"btn-main\" href=\"qds_rotation_lab.html\">Open Rotation Lab</a>";
  next
}
/Open Microphysics Lab/ {
  print "          <a class=\"btn-main\" href=\"qds_micro_lab.html\">Open Microphysics Lab</a>";
  next
}
{ print }
' "$FILE" > "${FILE}.tmp"

mv "${FILE}.tmp" "$FILE"

echo "✅ Updated lab links in $FILE:"
grep -nE "Open H0 Variance Lab|Open Rotation Lab|Open Microphysics Lab" "$FILE"
