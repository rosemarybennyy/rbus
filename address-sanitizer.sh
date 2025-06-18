#!/bin/sh

LOGFILE=$1
echo "Inside the script $LOG_FILE"
cat "$LOG_FILE"
LEAKS_FOUND=false
if grep -q "ERROR" "$LOGFILE"; then
  LEAKS_FOUND=true
  cat "$LOGFILE" >> $GITHUB_STEP_SUMMARY
  rm -rf $LOG_FILE
  exit 1
fi
