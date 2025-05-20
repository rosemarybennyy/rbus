#!/bin/bash

# Run Valgrind and save the output to a log file
valgrind --leak-check=full --log-file=valgrind.log ./your_program

# Parse the log file and convert to CSV
echo "Heap Summary,Error Summary,Leak Summary" > valgrind_table.csv

heap_summary=$(grep -A 5 "HEAP SUMMARY:" valgrind.log | tail -n 5 | tr '\n' ' ')
error_summary=$(grep "ERROR SUMMARY:" valgrind.log)
leak_summary=$(grep -A 4 "LEAK SUMMARY:" valgrind.log | tail -n 4 | tr '\n' ' ')

echo "$heap_summary,$error_summary,$leak_summary" >> valgrind_table.csv

echo "Conversion complete. Check valgrind_table.csv for the results."
