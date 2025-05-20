#!/bin/sh

LOG_FOLDER="/tmp"
SUMMARY_FILE="summary.txt"

echo "| Application | LEAK Summary | ERROR Summary | HEAP Summary |" > $SUMMARY_FILE
echo "| --- | --- | --- | --- |" >> $SUMMARY_FILE

for LOG_FILE in $LOG_FOLDER/*.log; do
  echo "Running logfile : $LOG_FILE"
  APP_NAME=$(basename $LOG_FILE .log)
  echo "Running app : $APP_NAME"

  if [ -f $LOG_FILE ]; then
    echo "Log file readable"
    LEAK_SUMMARY=$(awk '/LEAK SUMMARY:/, /^$/' $LOG_FILE | awk '{print $0 "<br>"}' | tr '\n' ' ')
    ERROR_SUMMARY=$(awk '/ERROR SUMMARY:/, /^$/' $LOG_FILE | awk '{print $0 "<br>"}' | tr '\n' ' ')
    HEAP_SUMMARY=$(awk '/HEAP SUMMARY:/, /^$/' $LOG_FILE | awk '{print $0 "<br>"}' | tr '\n' ' ')

    LEAK_SUMMARY=${LEAK_SUMMARY:-"No leaks found"}
    ERROR_SUMMARY=${ERROR_SUMMARY:-"No errors found"}
    HEAP_SUMMARY=${HEAP_SUMMARY:-"No heap summary found"}
    echo "| $APP_NAME | $LEAK_SUMMARY | $ERROR_SUMMARY | $HEAP_SUMMARY |" >> $SUMMARY_FILE
  else
    echo "Log file does not exist"
  fi
done

cat $SUMMARY_FILE
