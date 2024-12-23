#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 source_dir1 [source_dir2 ...] target_dir"
    exit 1
fi

# Get the last argument as the target directory
target_dir="${@: -1}"

# Remove the last argument from the list to get source directories
set -- "${@:1:$(($#-1))}"

# Check if target directory exists and is not empty
if [ -d "$target_dir" ] && [ "$(ls -A $target_dir)" ]; then
    echo "Target directory exists and is not empty"
    echo "Cleaning $target_dir..."
    rm -rf "${target_dir:?}"/*
fi

# Create target directory if it doesn't exist
mkdir -p "$target_dir"

# Function to handle filename conflicts
handle_conflict() {
    local filename="$1"
    local base="${filename%.*}"
    local ext="${filename##*.}"
    local counter=1
    local new_name

    if [ "$filename" = "$base" ]; then
        ext=""
    else
        ext=".$ext"
    fi

    while true; do
        new_name="${base}_${counter}${ext}"
        if [ ! -f "$target_dir/$new_name" ]; then
            echo "$new_name"
            return
        fi
        ((counter++))
    done
}

# Process each source directory
for src_dir in "$@"; do
    if [ ! -d "$src_dir" ]; then
        echo "Warning: '$src_dir' is not a directory, skipping..."
        continue
    fi

    echo "Processing directory: $src_dir"
    
    # Find all files excluding important directories and file types
    find "$src_dir" \
        -type d \( \
            -name "node_modules" -o \
            -name ".git" -o \
            -name ".github" -o \
            -name ".gitlab" -o \
            -name ".svn" -o \
            -name ".hg" -o \
            -name ".next" -o \
            -name "dist" -o \
            -name "build" -o \
            -name ".env" -o \
            -name ".temp" -o \
            -name "public" \
        \) -prune -o \
        -type f \( \
            ! -name "*.jpg" -a \
            ! -name "*.png" -a \
            ! -name "*.jpeg" -a \
            ! -name "*.svg" -a \
            ! -name "*.gif" -a \
            ! -name "*.webp" -a \
            ! -name "*.mp4" -a \
            ! -name "*.webm" -a \
            ! -name "*.ogg" -a \
            ! -name "*.mp3" -a \
            ! -name "*.ico" -a \
            ! -name "*.sh" \
            ! -name "*.lock" \
        \) \
        ! -path "*/\.*" \
        -print | while read -r file; do
        
        # Additional safety check for hidden and system files
        if [[ "$file" == *"/."* ]] || [[ "$file" == *"node_modules"* ]] || [[ "$file" == *".git"* ]]; then
            continue
        fi
        
        filename=$(basename "$file")
        
        # Check if file already exists in target directory
        if [ -f "$target_dir/$filename" ]; then
            new_filename=$(handle_conflict "$filename")
            echo "Copying: $file -> $target_dir/$new_filename"
            cp "$file" "$target_dir/$new_filename"
        else
            echo "Copying: $file -> $target_dir/$filename"
            cp "$file" "$target_dir/"
        fi
    done
done

echo "All files have been copied to $target_dir"
echo "Original directory structure remains intact"