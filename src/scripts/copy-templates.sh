#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Get the project root directory (parent of src)
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# Check if target directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target-directory>"
    echo "Example: $0 my-project"
    exit 1
fi

TARGET_DIR="$1"

# Ensure source templates exist
if [ ! -d "$PROJECT_ROOT/src/templates" ]; then
    echo "Error: Template directory not found at $PROJECT_ROOT/src/templates"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy templates to target directory
echo "Copying templates to $TARGET_DIR..."
cp -r "$PROJECT_ROOT/src/templates/" "$TARGET_DIR/"

echo "Templates copied successfully to $TARGET_DIR"