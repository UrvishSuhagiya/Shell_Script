#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 path_to_log_file"
    exit 1
}

# Check if the log file path is provided
if [ $# -ne 1 ]; then
    usage
fi

LOG_FILE=$1

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file $LOG_FILE does not exist."
    exit 1
fi

# Variables
ERROR_KEYWORD="ERROR"
CRITICAL_KEYWORD="CRITICAL"
DATE=$(date +"%Y-%m-%d")
SUMMARY_REPORT="summary_report_$DATE.txt"
ARCHIVE_DIR="processed_logs"

# Create a summary report
{
    echo "Date of analysis: $DATE"
    echo "Log file name: $LOG_FILE"
} > "$SUMMARY_REPORT"

# Total lines processed
TOTAL_LINES=$(wc -l < "$LOG_FILE")
echo "Total lines processed: $TOTAL_LINES" >> "$SUMMARY_REPORT"

# Count the number of error messages
ERROR_COUNT=$(grep -c "$ERROR_KEYWORD" "$LOG_FILE")
echo "Total error count: $ERROR_COUNT" >> "$SUMMARY_REPORT"

# List of critical events with line numbers
echo "List of critical events with line numbers:" >> "$SUMMARY_REPORT"
grep -n "$CRITICAL_KEYWORD" "$LOG_FILE" >> "$SUMMARY_REPORT"

# Initialize the associative array for error messages
declare -A error_messages

# Read the log file line by line
while IFS= read -r line; do
    if [[ "$line" == *"$ERROR_KEYWORD"* ]]; then
        # Extract the message after the ERROR keyword
        message=$(echo "$line" | sed "s/.*$ERROR_KEYWORD: //")
        ((error_messages["$message"]++))
    fi
done < "$LOG_FILE"

# Sort and display top 5 error messages
echo "Top 5 error messages with their occurrence count:" >> "$SUMMARY_REPORT"
for message in "${!error_messages[@]}"; do
    echo "${error_messages[$message]} $message"
done | sort -rn | head -n 5 >> "$SUMMARY_REPORT"

# Print the summary report
cat "$SUMMARY_REPORT"

# Archive the processed log file
mkdir -p "$ARCHIVE_DIR"
mv "$LOG_FILE" "$ARCHIVE_DIR"

echo "Log file has been archived to $ARCHIVE_DIR"
echo "Summary report has been saved to $SUMMARY_REPORT"
