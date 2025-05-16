#!/bin/bash

# Path to the Valgrind XML file
VALGRIND_XML="provider_valgrind_procinfo.xml"

# Check if the Valgrind XML file exists
if [ ! -f "$VALGRIND_XML" ]; then
  echo "Valgrind XML file not found!"
  exit 1
fi

# Parse the XML file to check for errors
ERRORS=$(grep -c "<error>" "$VALGRIND_XML")

if [ "$ERRORS" -gt 0 ]; then
  echo "Memory leaks detected!"
  grep "<error>" -A 10 "$VALGRIND_XML" > commit_message.txt
  exit 1
else
  echo "No memory leaks detected." > commit_message.txt
  exit 0
fi
