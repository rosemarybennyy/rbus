#!/bin/sh

LOGFILE=$1
echo "Inside the script $LOGFILE"
LEAKS_FOUND=false
if grep -q "ERROR" "$LOGFILE"; then
  LEAKS_FOUND=true
  cat "$LOGFILE" >> $GITHUB_STEP_SUMMARY
  rm -rf $LOGFILE
  cd /tmp
  ls -lt
  exit 1
fi
