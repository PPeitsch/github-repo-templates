#!/bin/bash

# Function to check if a file or directory exists
check_exists() {
    if [ ! -e "$1" ]; then
        echo "Error: $1 not found"
        exit 1
    fi
}

# Function to ensure directory exists
ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "Created directory: $1"
    fi
}

echo "Starting migration process..."

# Create new directory structure
ensure_dir "src/templates/.github/ISSUE_TEMPLATE"
ensure_dir ".github/ISSUE_TEMPLATE"

# Check if source directories exist
check_exists ".github"

echo "Moving template files..."

# First, copy all .github contents to templates
if [ -d ".github" ]; then
    # Copy ISSUE_TEMPLATE contents
    if [ -d ".github/ISSUE_TEMPLATE" ]; then
        cp -r .github/ISSUE_TEMPLATE/* src/templates/.github/ISSUE_TEMPLATE/
        echo "Copied ISSUE_TEMPLATE files"
    fi

    # Copy individual files from .github
    for file in .github/*.md; do
        if [ -f "$file" ]; then
            cp "$file" "src/templates/.github/"
            echo "Copied $(basename "$file")"
        fi
    done
fi

# Copy README template if it exists
if [ -f "README-template.md" ]; then
    cp "README-template.md" "src/templates/"
    echo "Copied README template"
fi

# Create this project's own GitHub files
echo "Creating project's own GitHub files..."
if [ -d "src/templates/.github" ]; then
    cp -r src/templates/.github/* .github/
    echo "Created project's GitHub files"
fi

echo "Migration completed successfully!"