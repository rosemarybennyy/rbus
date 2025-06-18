#!/bin/bash

LOGFILE=$1
cat $LOG_FILE
LEAKS_FOUND=false
if grep -q "ERROR" "$LOGFILE"; then
  LEAKS_FOUND=true
  cat "$LOGFILE" >> $GITHUB_STEP_SUMMARY
  rm -rf $LOG_FILE
  exit 1
fi
