#!/bin/bash

LOGFILE=$1
cat $LOG_FILE
if grep -q "ERROR" "$LOGFILE"; then
  cat "$LOGFILE" >> $GITHUB_STEP_SUMMARY
fi
