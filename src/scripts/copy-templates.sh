#!/bin/bash

# Check if target directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target-directory>"
    echo "Example: $0 my-project"
    exit 1
fi

TARGET_DIR="$1"

# Ensure source templates exist
if [ ! -d "src/templates" ]; then
    echo "Error: Template directory not found at src/templates"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy templates to target directory
echo "Copying templates to $TARGET_DIR..."
cp -r src/templates/* "$TARGET_DIR/"

echo "Templates copied successfully to $TARGET_DIR"