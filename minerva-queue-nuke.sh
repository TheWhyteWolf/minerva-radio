#!/bin/bash
# --- CONFIGURATION ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CSV_FILE="$SCRIPT_DIR/vgm_catalogue.csv"
QUEUE_FILE="/tmp/vgm_queue"

# --- VALIDATION ---
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: CSV catalogue not found."
    exit 1
fi

if [ ! -f "$QUEUE_FILE" ]; then
    echo "Error: VGM Radio does not appear to be running."
    exit 1
fi

truncate -s 0 "$QUEUE_FILE"

echo "Q Nuked"
