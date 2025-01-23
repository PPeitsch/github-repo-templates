#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/../.." &> /dev/null && pwd )"

# Check if target directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target-directory>"
    echo "Example: $0 my-project"
    exit 1
fi

TARGET_DIR="${1%/}"  # Remove trailing slash if present

# Ensure source templates exist
TEMPLATES_DIR="$PROJECT_ROOT/src/templates"
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "Error: Template directory not found at $TEMPLATES_DIR"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy templates to target directory
echo "Copying templates to $TARGET_DIR..."

# Copy each component separately
cp -r "$TEMPLATES_DIR/.github" "$TARGET_DIR/"
cp "$TEMPLATES_DIR/README-template.md" "$TARGET_DIR/"
cp "$TEMPLATES_DIR/template-config.yml" "$TARGET_DIR/"

echo "Templates copied successfully to $TARGET_DIR"