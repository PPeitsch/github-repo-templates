#!/bin/bash

# Check if project directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project-directory>"
    exit 1
fi

PROJECT_DIR="${1%/}"  # Remove trailing slash if present
CONFIG_FILE="$PROJECT_DIR/template-config.yml"
LOG_FILE="$PROJECT_DIR/template-setup.log"

# Initialize log file
echo "Template Setup Log - $(date)" > "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

log_message() {
    echo "$1" | tee -a "$LOG_FILE"
}

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    log_message "Error: Configuration file $CONFIG_FILE not found"
    exit 1
fi

# Function to parse yaml and create variable replacements
parse_yaml() {
    local yaml_file=$1
    local s='[[:space:]]*'
    local w='[a-zA-Z0-9_]*'
    local fs=$(echo @|tr @ '\034')

    sed -ne 's/^#.*//;/^[[:space:]]*$/d' \
        -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s'\(.*\)'$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$yaml_file" | \
    awk -F$fs '{
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

log_message "Processing template files..."
log_message "Variables loaded from config:"
while IFS='=' read -r var value; do
    log_message "  $var = $value"
done < "$TEMP_VARS"

# Process all markdown and yml files in the project directory
find "$PROJECT_DIR" -type f \( -name "*.md" -o -name "*.yml" \) | while read -r file; do
    log_message "Processing file: $file"

    # Create temporary file for processing
    TEMP_FILE=$(mktemp 2>/dev/null || mktemp -t tmp.XXXXXX)
    cp "$file" "$TEMP_FILE"

    # Read and apply each variable replacement
    while IFS='=' read -r var value; do
        # Preserve newlines and special characters
        value=$(echo "$value" | sed 's/[\/&]/\\&/g')
        template_var="{{$var}}"

        # Check if variable exists in file before replacing
        if grep -q "$template_var" "$TEMP_FILE"; then
            log_message "  Replacing $template_var with '$value'"
            # Use perl for more reliable replacement
            perl -i -pe "BEGIN{undef $/;} s/\Q$template_var\E/$value/gm" "$TEMP_FILE"
        fi
    done < "$TEMP_VARS"

    mv "$TEMP_FILE" "$file"
done

# Cleanup
rm -f "$TEMP_VARS"

log_message "----------------------------------------"
log_message "Template setup completed successfully!"