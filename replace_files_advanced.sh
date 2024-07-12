#!/bin/bash

# Temporary file for the user to edit the lines
TEMP_FILE=$(mktemp)

# Function to clean up the temporary file and exit
cleanup() {
    rm -f "$TEMP_FILE"
    exit
}

# Capture signals to clean up
trap cleanup INT TERM

# Ask for the range of lines to edit
read -p "Enter the starting line number to edit: " start_line
read -p "Enter the ending line number to edit: " end_line

# Instruct the user to edit the lines
echo "Edit the file that will open to enter the new lines."
echo "These lines will replace the lines from $start_line to $end_line in each file."
read -p "Press Enter to continue..."

# Open the temporary file with nano
nano "$TEMP_FILE"

# Ask for the folder path
read -p "Enter the path to the folder: " folder_path

# Function to replace lines in a file
replace_lines_in_file() {
    local file_path=$1
    local temp_file=$(mktemp)
    local line_num=1

    while IFS= read -r line; do
        if [ $line_num -lt $start_line ] || [ $line_num -gt $end_line ]; then
            echo "$line" >> "$temp_file"
        fi
        if [ $line_num -eq $start_line ]; then
            cat "$TEMP_FILE" >> "$temp_file"
        fi
        ((line_num++))
    done < "$file_path"

    mv "$temp_file" "$file_path"
}

# Iterate over the files in the folder and apply replacements
for file in "$folder_path"/*; do
    if [ -f "$file" ]; then
        replace_lines_in_file "$file"
    fi
done

# Clean up the temporary file
cleanup

echo "Lines replaced successfully."
