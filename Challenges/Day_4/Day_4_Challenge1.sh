#!/bin/bash

# Check if the process name is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <process_name>"
    exit 1
fi

PROCESS_NAME=$1
MAX_RESTARTS=3
RESTART_COUNT=0

# Function to check if the process is running
check_process() {
    pgrep "$PROCESS_NAME" > /dev/null 2>&1
    return $?
}

# Function to restart the process
restart_process() {
    echo "Attempting to restart $PROCESS_NAME..."
    # Replace the following line with the actual command to start the process
    $PROCESS_NAME &
    RESTART_COUNT=$((RESTART_COUNT + 1))
    if [ $RESTART_COUNT -ge $MAX_RESTARTS ]; then
        echo "Max restart attempts reached. Manual intervention required."
        # Add notification logic here (e.g., email or Slack message)
    fi
}

# Monitor loop
while true; do
    check_process
    if [ $? -ne 0 ]; then
        echo "$PROCESS_NAME is not running."
        restart_process
    else
        echo "$PROCESS_NAME is running."
    fi
    sleep 60  # Check every 60 seconds
done
