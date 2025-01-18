#!/bin/bash

# Check if project directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project-directory>"
    exit 1
fi

PROJECT_DIR="$1"
CONFIG_FILE="template-config.yml"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found"
    exit 1
fi

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory $PROJECT_DIR not found"
    exit 1
fi

# Function to read nested yaml values
get_yaml_values() {
    local prefix=$2
    local yaml_file=$1
    local s='[[:space:]]*'
    local w='[a-zA-Z0-9_]*'
    local fs=$(echo @|tr @ '\034')

    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\'\(.*\)\'$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$yaml_file" |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=\"%s\"\n", "'$prefix'", vn, $2, $3);
        }
    }'
}

# Create temporary file for variable mappings
TEMP_VARS=$(mktemp)

# Get all variables from config file with their full paths
get_yaml_values "$CONFIG_FILE" "" > "$TEMP_VARS"

echo "Processing template files..."

# Find all template files
find "$PROJECT_DIR/.github" -type f \( -name "*.md" -o -name "*.yml" \) | while read file; do
    echo "Processing $file..."

    # Create a temporary file for the processed content
    temp_file=$(mktemp)
    cp "$file" "$temp_file"

    # Read each variable mapping and perform substitution
    while IFS='=' read -r var value; do
        # Remove quotes from value
        value=$(echo "$value" | sed 's/^"//;s/"$//')
        # Create the template variable format {{VAR_NAME}}
        template_var="{{${var}}}"
        # Replace in the temporary file
        sed -i.bak "s|${template_var}|${value}|g" "$temp_file"
    done < "$TEMP_VARS"

    # Move processed file back to original location
    mv "$temp_file" "$file"
done

# Cleanup
rm "$TEMP_VARS"
rm -f "$PROJECT_DIR/.github"/*.bak

echo "Template setup completed successfully!"