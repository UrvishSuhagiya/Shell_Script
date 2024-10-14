#!/bin/bash

# Welcome message
echo "Welcome to the Interactive File and Directory Explorer!"

# Display files and directories in the current path
while true; do
  echo "Files and Directories in the current path:"
  ls -lh --group-directories-first
  echo ""

  # Prompt user to enter a command
  read -p "Enter 'exit' to quit, or press Enter to continue: " command

  # Exit the explorer if user enters 'exit'
  if [ "$command" = "exit" ]; then
    break
  fi
done

# Character counting feature
echo "Character Counting Feature:"
while true; do
  read -p "Enter a line of text (or press Enter to quit): " input

  # Exit the character counting feature if user enters an empty string
  if [ -z "$input" ]; then
    break
  fi

  # Count the number of characters in the input string
  char_count=$(echo -n "$input" | wc -m)
  echo "Character count: $char_count"
done

echo "Goodbye!"
