#!/bin/bash

# This script takes an input file, applies a series of transformations, and outputs the result to a specified file.
# Transformations include ROT13 encoding/decoding and multiple content reversals.

# Function to perform the enigmatic transformations
transform_content() {
    local infile="$1"
    local outfile="$2"

    # Step 1: Perform ROT13 transformation on the input file
    tr 'A-Za-z' 'N-ZA-Mn-za-m' < "$infile" > "$outfile"

    # Step 2: Reverse the contents of the transformed file
    rev "$outfile" > "temp_reversed.txt"

    # Step 3: Generate a random number between 1 and 10 for iteration
    local num=$(( RANDOM % 10 + 1 ))

    # Step 4: Repeat the reverse and ROT13 steps several times
    for (( i=0; i<num; i++ )); do
        # Reverse the content again
        rev "temp_reversed.txt" > "temp_rev.txt"

        # Apply ROT13 transformation again to the reversed content
        tr 'A-Za-z' 'N-ZA-Mn-za-m' < "temp_rev.txt" > "temp_enc.txt"

        # Overwrite the intermediate file for the next iteration
        mv "temp_enc.txt" "temp_reversed.txt"
    done

    # Step 5: Remove the temporary file used during transformations
    rm "temp_rev.txt"
}

# Main script execution starts here

# Check for the correct number of arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

infile="$1"
outfile="$2"

# Verify the input file exists
if [ ! -f "$infile" ]; then
    echo "Error: Input file '$infile' not found!"
    exit 1
fi

# Call the function to start the transformations
transform_content "$infile" "$outfile"

# Notify the user of completion
echo "Transformation complete. Check the result in '$outfile'."
