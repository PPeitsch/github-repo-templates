#!/bin/bash

# Check if project directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project-directory>"
    exit 1
fi

PROJECT_DIR="${1%/}"  # Remove trailing slash if present
CONFIG_FILE="$PROJECT_DIR/template-config.yml"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found"
    exit 1
fi

# Function to parse yaml and create variable replacements
parse_yaml() {
    local yaml_file=$1
    local prefix=$2
    local s='[[:space:]]*'
    local w='[a-zA-Z0-9_]*'
    local fs=$(echo @|tr @ '\034')

    sed -e '/^#/d' \
        -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\'\(.*\)\'$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" \
        "$yaml_file" | awk -F$fs '{
            indent = length($1)/2;
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
            if (length($3) > 0) {
                vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                if(vn==""){ printf("%s=%s\n", toupper($2), $3)}
                else { printf("%s_%s=%s\n", toupper(vn), toupper($2), $3)}
            }
        }'
}

# Create temporary file for processed variables
TEMP_VARS=$(mktemp 2>/dev/null || mktemp -t tmp.XXXXXX)

# Parse YAML and store variables
parse_yaml "$CONFIG_FILE" > "$TEMP_VARS"

echo "Processing template files..."

# Process all markdown and yml files in the project directory
find "$PROJECT_DIR" -type f \( -name "*.md" -o -name "*.yml" \) | while read -r file; do
    echo "Processing $file..."

    # Create temporary file for processing
    TEMP_FILE=$(mktemp 2>/dev/null || mktemp -t tmp.XXXXXX)
    cp "$file" "$TEMP_FILE"

    # Read and apply each variable replacement
    while IFS='=' read -r var value; do
        value=$(echo "$value" | sed 's/^[[:space:]]*"//;s/"[[:space:]]*$//;s/^[[:space:]]*//;s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/[\/&]/\\&/g')
        template_var="{{$var}}"
        perl -i -pe "s/\Q$template_var\E/$value/g" "$TEMP_FILE"
    done < "$TEMP_VARS"

    mv "$TEMP_FILE" "$file"
done

# Cleanup
rm -f "$TEMP_VARS"

echo "Template setup completed successfully!"