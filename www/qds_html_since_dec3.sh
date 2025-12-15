#!/data/data/com.termux/files/usr/bin/bash
echo "=== HTML files since 2025-12-03 ==="
find /storage/emulated/0 \
     /data/data/com.termux/files/home \
     -type f -name "*.html" \
     -newermt "2025-12-03" \
     -printf '%TY-%Tm-%Td %TH:%TM  %p\n' \
  2>/dev/null | sort
echo "==================================="
