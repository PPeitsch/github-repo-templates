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
    local current_var=""
    local in_multiline=0
    local multiline_content=""

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        [[ $line =~ ^[[:space:]]*# ]] && continue
        [[ $line =~ ^[[:space:]]*$ ]] && continue

        # Check if this is a new variable definition
        if [[ $line =~ ^[[:space:]]*([A-Za-z0-9_]+):[[:space:]]*(.*) ]]; then
            # If we were processing a multiline value, output it
            if [ $in_multiline -eq 1 ]; then
                # Eliminar espacios al final y asegurar que no haya "=" extras
                multiline_content=$(echo "$multiline_content" | sed 's/[[:space:]]*$//')
                printf '%s=%s\n' "$current_var" "$multiline_content"
                in_multiline=0
                multiline_content=""
            fi

            current_var="${BASH_REMATCH[1]}"
            content="${BASH_REMATCH[2]}"

            # Remove quotes and leading/trailing spaces
            content=$(echo "$content" | sed -E 's/^[[:space:]]*"?([^"]*)"?[[:space:]]*$/\1/')

            # Check if this is the start of a multiline value
            if [[ $content =~ ^\| ]]; then
                in_multiline=1
                multiline_content=""
            else
                # Single line value - trim spaces
                content=$(echo "$content" | sed 's/[[:space:]]*$//')
                printf '%s=%s\n' "$current_var" "$content"
            fi
        elif [ $in_multiline -eq 1 ]; then
            # Trim exactly two leading spaces from multiline content
            local trimmed_line=$(echo "$line" | sed 's/^  //')
            # Trim trailing spaces
            trimmed_line=$(echo "$trimmed_line" | sed 's/[[:space:]]*$//')
            if [ -n "$multiline_content" ]; then
                multiline_content+=$'\n'
            fi
            multiline_content+="$trimmed_line"
        fi
    done < "$yaml_file"

    # Handle last multiline value if exists
    if [ $in_multiline -eq 1 ]; then
        multiline_content=$(echo "$multiline_content" | sed 's/[[:space:]]*$//')
        printf '%s=%s\n' "$current_var" "$multiline_content"
    fi
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
        template_var="{{$var}}"

        # Check if variable exists in file before replacing
        if grep -F -q "$template_var" "$TEMP_FILE"; then
            # Restauramos el logging del valor de reemplazo
            log_message "  Replacing $template_var with '$value'"
            # Escape special characters properly for sed
            value=$(printf '%s' "$value" | sed -e 's/[\&/=]/\\&/g')
            sed -i "s/{{$var}}/$value/g" "$TEMP_FILE"
        fi
    done < "$TEMP_VARS"

    mv "$TEMP_FILE" "$file"
done

# Cleanup
rm -f "$TEMP_VARS"

log_message "----------------------------------------"
log_message "Template setup completed successfully!"