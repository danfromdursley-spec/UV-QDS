#!/data/data/com.termux/files/usr/bin/bash
# qds_short_list.sh  — quick counts for QDS stuff

HOME_DIR="$HOME"
PHONE_DIRS="/sdcard /storage/emulated/0"

echo "=== QDS QUICK FILE STATS ==="

# Python
py_termux=$(find "$HOME_DIR"    -type f -name "*.py"    2>/dev/null | wc -l)
py_phone=$(find $PHONE_DIRS     -type f -name "*.py"    2>/dev/null | wc -l)
# HTML
html_termux=$(find "$HOME_DIR"  -type f -name "*.html"  2>/dev/null | wc -l)
html_phone=$(find $PHONE_DIRS   -type f -name "*.html"  2>/dev/null | wc -l)
# Anything with “qds” in the name (files + dirs)
qds_termux=$(find "$HOME_DIR"   -iname "*qds*"          2>/dev/null | wc -l)
qds_phone=$(find $PHONE_DIRS    -iname "*qds*"          2>/dev/null | wc -l)

total_py=$((py_termux + py_phone))
total_html=$((html_termux + html_phone))
total_qds=$((qds_termux + qds_phone))

echo "Python (Termux) : $py_termux"
echo "Python (Phone)  : $py_phone"
echo "Python (TOTAL)  : $total_py"
echo
echo "HTML (Termux)   : $html_termux"
echo "HTML (Phone)    : $html_phone"
echo "HTML (TOTAL)    : $total_html"
echo
echo "\"qds\" names (Termux): $qds_termux"
echo "\"qds\" names (Phone) : $qds_phone"
echo "\"qds\" names (TOTAL) : $total_qds"
echo "============================="
