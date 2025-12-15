#!/data/data/com.termux/files/usr/bin/bash

DATE_FROM="2025-10-01"   # change this if you ever want a different start date

echo "=== QDS FILE STATS SINCE $DATE_FROM ==="

# ------- Python -------
py_termux=$(find "$HOME" -type f -name "*.py" -newermt "$DATE_FROM" 2>/dev/null | wc -l)
py_phone=$(find /storage/emulated/0 /sdcard -type f -name "*.py" -newermt "$DATE_FROM" 2>/dev/null | wc -l)
py_total=$((py_termux + py_phone))

# ------- HTML -------
html_termux=$(find "$HOME" -type f -name "*.html" -newermt "$DATE_FROM" 2>/dev/null | wc -l)
html_phone=$(find /storage/emulated/0 /sdcard -type f -name "*.html" -newermt "$DATE_FROM" 2>/dev/null | wc -l)
html_total=$((html_termux + html_phone))

# ------- Names containing "qds" (files + folders) -------
qds_termux=$(find "$HOME" -iname "*qds*" -newermt "$DATE_FROM" 2>/dev/null | wc -l)
qds_phone=$(find /storage/emulated/0 /sdcard -iname "*qds*" -newermt "$DATE_FROM" 2>/dev/null | wc -l)
qds_total=$((qds_termux + qds_phone))

echo "Python (Termux) : $py_termux"
echo "Python (Phone)  : $py_phone"
echo "Python (TOTAL)  : $py_total"
echo
echo "HTML (Termux)   : $html_termux"
echo "HTML (Phone)    : $html_phone"
echo "HTML (TOTAL)    : $html_total"
echo
echo "\"qds\" names (Termux): $qds_termux"
echo "\"qds\" names (Phone) : $qds_phone"
echo "\"qds\" names (TOTAL) : $qds_total"
echo "============================="
