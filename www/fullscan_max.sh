#!/data/data/com.termux/files/usr/bin/bash
echo "=== FULL ANDROID MAXIMUM SCAN ==="
echo "Time: $(date)"
echo "Including hidden & restricted directories"
echo

# Ask Android for full storage access
termux-setup-storage >/dev/null 2>&1

TARGETS=(
  "/storage/emulated/0"
  "/sdcard"
  "/mnt"
  "/storage"
  "/data/data/com.termux/files/home"
)

COUNT=0

for DIR in "${TARGETS[@]}"; do
    echo "--- Scanning: $DIR ---"
    DIR_COUNT=$(find "$DIR" -type f 2>/dev/null | wc -l)
    echo "$DIR_COUNT files"
    COUNT=$((COUNT + DIR_COUNT))
    echo
done

echo "=== TOTAL FILES ACROSS ALL TARGETS ==="
echo "$COUNT files found"
echo "=== COMPLETE ==="
