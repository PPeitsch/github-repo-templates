#!/bin/bash

# Check if target directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target-directory>"
    echo "Example: $0 my-project"
    exit 1
fi

TARGET_DIR="$1"

echo "Starting template setup process..."

# First, copy templates
echo "Copying templates..."
if ! ./scripts/copy-templates.sh "$TARGET_DIR"; then
    echo "Error: Failed to copy templates"
    exit 1
fi

# Then, replace variables
echo "Replacing variables..."
if ! ./scripts/setup-script.sh "$TARGET_DIR"; then
    echo "Error: Failed to replace variables"
    exit 1
fi

echo "Template setup completed successfully!"