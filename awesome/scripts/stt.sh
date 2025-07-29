#!/bin/bash

LOGFILE="/tmp/stt.log"

# Activate your venv if needed
source ~/python-libs/venv/bin/activate

# Optional: change dir if needed
cd ~/code/python/s2s/ || exit 1

echo "==== START $(date) ====" >>"$LOGFILE"
python3 tryig.py >>"$LOGFILE" 2>&1
echo "==== END ====" >>"$LOGFILE"
