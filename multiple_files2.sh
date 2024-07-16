#!/bin/bash

# Ask for the path of the file to be copied
read -p "Enter the path of the file to be copied: " file_path
read -p "Enter the path of the folder containing test_suites_info.json: " folder_path

# Check if the file and test_suites_info.json exist
if [[ ! -f "$file_path" ]]; then
    echo "The file $file_path does not exist."
    exit 1
fi

json_file="$folder_path/test_suites_info.json"
if [[ ! -f "$json_file" ]]; then
    echo "The file $json_file does not exist."
    exit 1
fi

# Ask for the dictionary name in test_suites_info.json
read -p "Enter the dictionary name in test_suites_info.json: " dict_name

# Extract dictionary from JSON
dict_content=$(jq -r ".$dict_name" "$json_file")
if [[ "$dict_content" == "null" ]]; then
    echo "The dictionary $dict_name does not exist in test_suites_info.json."
    exit 1
fi

# Create the output directory if it doesn't exist
output_dir="modified_files"
mkdir -p "$output_dir"

# Iterate over each key-value pair in the dictionary
keys=$(jq -r "keys[]" <<< "$dict_content")

for key in $keys; do
    # Create a copy of the specified file
    file_extension="${file_path##*.}"
    new_file_name="$output_dir/$key.$file_extension"
    cp "$file_path" "$new_file_name"

    # Modify the content of the new file
    new_name=$(echo "$key" | tr '[:upper:]_' '[:lower:]-')
    dict_underscore_name="PARAMS_$dict_name"
    sed -i '' "4s|name:.*|name: $new_name|" "$new_file_name"
    sed -i '' "60s|.*|        $key|" "$new_file_name"

    echo "Created and modified file: $new_file_name"
done

echo "All files created and modified successfully in the directory: $output_dir."
