
#!/bin/bash

# Run Valgrind and save the output to a log file
valgrind --leak-check=full --log-file=valgrind.log ./your_program

# Parse the log file and convert to CSV
echo "Type,Bytes,Blocks" > valgrind_table.csv
grep -E "definitely lost|indirectly lost" valgrind.log | while read -r line; do
    type=$(echo $line | awk '{print $1}')
    bytes=$(echo $line | awk '{print $4}')
    blocks=$(echo $line | awk '{print $6}')
    echo "$type,$bytes,$blocks" >> valgrind_table.csv
done
echo "Conversion complete. Check valgrind_table.csv for the results."
