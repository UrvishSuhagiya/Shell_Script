#!/bin/bash

SLEEP_INTERVAL=5  # Default sleep interval

# Function to display system metrics
show_metrics() {
    echo "=========================="
    echo "CPU Usage:"
    top -b -n1 | grep "Cpu(s)"
    echo "Memory Usage:"
    free -h
    echo "Disk Usage:"
    df -h
    echo "=========================="
}

# Function to monitor a specific service
monitor_service() {
    SERVICE_NAME=$1
    systemctl is-active --quiet $SERVICE_NAME
    if [ $? -eq 0 ]; then
        echo "$SERVICE_NAME is running."
    else
        echo "$SERVICE_NAME is not running."
        read -p "Do you want to start $SERVICE_NAME? (y/n): " REPLY
        if [ "$REPLY" == "y" ]; then
            sudo systemctl start $SERVICE_NAME
            echo "$SERVICE_NAME started."
        fi
    fi
}

# Main menu
while true; do
    echo "1. Show system metrics"
    echo "2. Monitor a service (e.g., Nginx)"
    echo "3. Set sleep interval (current: $SLEEP_INTERVAL seconds)"
    echo "4. Exit"
    read -p "Choose an option: " OPTION

    case $OPTION in
        1)
            while true; do
                show_metrics
                sleep $SLEEP_INTERVAL
            done
            ;;
        2)
            read -p "Enter the service name to monitor: " SERVICE_NAME
            monitor_service $SERVICE_NAME
            ;;
        3)
            read -p "Enter new sleep interval (seconds): " SLEEP_INTERVAL
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
