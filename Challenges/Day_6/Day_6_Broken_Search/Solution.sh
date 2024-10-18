#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <start_directory> <target_file>"
    exit 1
}

# Function to perform the recursive search
search_directory() {
    local current_directory="$1"
    local target_file="$2"

    # Check if the directory exists
    if [ ! -d "$current_directory" ]; then
        echo "Error: Directory '$current_directory' does not exist."
        exit 1
    fi

    # Loop through the items in the current directory
    for item in "$current_directory"/*; do
        # Check if the item is a directory
        if [ -d "$item" ]; then
            # Recursively search the subdirectory
            search_directory "$item" "$target_file"
        elif [ -f "$item" ]; then
            # Check if the file matches the target file
            if [ "$(basename "$item")" == "$target_file" ]; then
                echo "File found: $(realpath "$item")"
                exit 0
            fi
        fi
    done
}

# Main script execution starts here

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
    usage
fi

start_directory="$1"
target_file="$2"

# Start the recursive search
search_directory "$start_directory" "$target_file"

# If the script reaches this point, the file was not found
echo "File not found: $target_file"
exit 1
