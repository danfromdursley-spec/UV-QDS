#!/bin/bash

# Full Android file scan in Termux
START_DATE="2025-10-20"

echo "=== FULL ANDROID STORAGE SCAN (TERMUX) ==="
echo "Files modified since: $START_DATE"
echo

# DIRECTORIES TO SCAN
DIRS=(
  "/storage/emulated/0"
  "/sdcard"
  "/mnt"
  "/storage"
  "$HOME"
  "/data/data"
)

echo "Scanning directories:"
printf '%s\n' "${DIRS[@]}"
echo

# MASTER COUNTER
echo "--- TOTAL FILES ---"
find "${DIRS[@]}" -type f -newermt "$START_DATE" 2>/dev/null | wc -l
echo

echo "--- FILES BY TYPE ---"

count_type() {
  EXT="$1"
  COUNT=$(find "${DIRS[@]}" -type f -newermt "$START_DATE" -iname "*.$EXT" 2>/dev/null | wc -l)
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
count_type ppt
count_type pptx
count_type md

# Media
count_type jpg
count_type jpeg
count_type png
count_type gif
count_type mp4
count_type mov
count_type avi
count_type mkv
count_type mp3
count_type wav

echo
echo "=== SCAN COMPLETE ==="
