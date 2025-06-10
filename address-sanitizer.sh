#!/bin/bash

LOGFILE=$1

if grep -q "ERROR" "$LOGFILE"; then
  cat "$LOGFILE" >> $GITHUB_STEP_SUMMARY
fi
