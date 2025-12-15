#!/data/data/com.termux/files/usr/bin/bash
cd ~/UV_QDS/www || exit 1
echo "=== HTML builds since midnight ==="
find . -type f -name "*.html" -newermt "today 00:00" \
  -printf "%TY-%Tm-%Td %TH:%TM  %p\n" | sort
