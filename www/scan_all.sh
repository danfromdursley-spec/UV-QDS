#!/bin/bash

# === SETTINGS ===
START_DATE="2025-10-20"
SCAN_DIR="/storage/emulated/0"   # Full internal storage
DATE_SEC=$(date -d "$START_DATE" +%s)

echo "=== QDS FILE SCAN REPORT ==="
echo "Scanning from: $SCAN_DIR"
echo "Files newer than: $START_DATE"
echo

# === Total files ===
echo "--- TOTAL FILES ---"
find "$SCAN_DIR" -type f -newermt "$START_DATE" 2>/dev/null | wc -l

echo
echo "--- FILES BY TYPE ---"

# helper function
count_type() {
  EXT="$1"
  COUNT=$(find "$SCAN_DIR" -type f -newermt "$START_DATE" -iname "*.$EXT" 2>/dev/null | wc -l)
  echo "$EXT : $COUNT"
}

# Code files
count_type py
count_type html
count_type js
count_type css
count_type json
count_type sh

# Documents
count_type txt
count_type pdf
count_type doc
count_type docx
count_type xls
count_type xlsx
count_type md

# Media
count_type jpg
count_type jpeg
count_type png
count_type gif
count_type mp4
count_type mov
count_type mp3
count_type wav
count_type avi

echo
echo "=== DONE ==="
