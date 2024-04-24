#!/bin/bash

if [ "$#" -ne 2 ]; then
    exit 1
fi

input_dir=$1
output_dir=$2

mkdir -p "$output_dir"

function copy_file {
    local file_path=$1
    local base_name=$(basename "$file_path")
    local destination="$output_dir/$base_name"

    if [[ -e $destination ]]; then
        local counter=1
        local file_extension="${base_name##*.}"
        local file_name="${base_name%.*}"

        while [[ -e "$output_dir/${file_name}_$counter.$file_extension" ]]; do
            ((counter++))
        done
        destination="$output_dir/${file_name}_$counter.$file_extension"
    fi


    cp "$file_path" "$destination"
}


find "$input_dir" -type f | while read -r file; do
    copy_file "$file"
done

