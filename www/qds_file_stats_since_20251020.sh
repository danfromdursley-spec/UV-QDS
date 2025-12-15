#!/data/data/com.termux/files/usr/bin/bash

DATE="2025-10-20"
BASE_DIRS="/storage/emulated/0 /data/data/com.termux/files/home"

stats() {
  label="$1"; shift
  echo
  echo ">> $label"
  find $BASE_DIRS -type f "$@" -newermt "$DATE" -printf '%s\n' 2>/dev/null \
    | awk '{
        n++; s+=$1
      }
      END {
        if (n==0) {
          print "Files: 0"
        } else {
          printf "Files: %d  Total: %d bytes (%.2f KB, %.2f MB)  Avg: %.1f bytes\n",
                 n, s, s/1024, s/1024/1024, s/n
        }
      }'
}

echo "=== QDS Big File Stats since $DATE ==="

echo
echo ">> ALL files (any type)"
find $BASE_DIRS -type f -newermt "$DATE" -printf '%s\n' 2>/dev/null \
  | awk '{
      n++; s+=$1
    }
    END {
      if (n==0) {
        print "Files: 0"
      } else {
        printf "Files: %d  Total: %d bytes (%.2f KB, %.2f MB)  Avg: %.1f bytes\n",
               n, s, s/1024, s/1024/1024, s/n
      }
    }'

# Breakdown by type
stats "Python (.py)"                -iname '*.py'
stats "Shell scripts (.sh)"         -iname '*.sh'
stats "HTML (.html)"                -iname '*.html'
stats "Word docs (.doc/.docx)"      \( -iname '*.doc' -o -iname '*.docx' \)
stats "PDFs (.pdf)"                 -iname '*.pdf'
stats "Text files (.txt)"           -iname '*.txt'
stats "JSON config/data (.json)"    -iname '*.json'
