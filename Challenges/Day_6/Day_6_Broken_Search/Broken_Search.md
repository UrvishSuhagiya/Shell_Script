# Recursive Directory Search Challenge

## Description

The "Recursive Directory Search" challenge is part of the day-6. In this challenge, participants are tasked with creating a Bash script that performs a recursive search for a specific file within a given directory and its subdirectories. The script provided for this challenge is not functioning correctly, and participants must fix and improve it to achieve the desired behavior.

## Challenge Details

**Objective:** Your goal is to fix the provided Bash script, `recursive_search.sh`, and ensure it performs the recursive search as described below:

- The script should take two command-line arguments: the directory to start the search and the target file name to find.
- The search should be recursive, meaning it should look for the target file not only in the specified directory but also in all its subdirectories and their subdirectories, and so on.
- When the target file is found, the script should print the absolute path of the file and then exit.
- Proper error handling should be in place to handle cases where the directory does not exist or the target file is not found.

**Provided Files:**

1. `recursive_search.sh`: The main script file that requires fixing and improvement.
