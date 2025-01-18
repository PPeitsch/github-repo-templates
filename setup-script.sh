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

# Function to read value from yaml file
parse_yaml() {
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\):|\1|" \
         -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
         -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s=\"%s\"\n", "'$prefix'",vn$2,$3);
        }
    }'
}

# Read config values
eval $(parse_yaml $CONFIG_FILE)

# Find and replace variables in all template files
echo "Replacing variables in template files..."

find "$PROJECT_DIR/.github" -type f -name "*.md" -o -name "*.yml" | while read file; do
    echo "Processing $file..."
    # Replace all variables from config
    sed -i.bak \
        -e "s|{{PROJECT_NAME}}|$project_name|g" \
        -e "s|{{PROJECT_DESCRIPTION}}|$project_description|g" \
        -e "s|{{OWNER_NAME}}|$project_owner|g" \
        -e "s|{{CONTACT_EMAIL}}|$project_email|g" \
        -e "s|{{SECURITY_EMAIL}}|$project_security_email|g" \
        -e "s|{{SUPPORT_EMAIL}}|$project_support_email|g" \
        -e "s|{{REPO_URL}}|$project_repo_url|g" \
        -e "s|{{DOCS_URL}}|$project_documentation_url|g" \
        -e "s|{{LICENSE_TYPE}}|$project_license|g" \
        -e "s|{{LICENSE_URL}}|$project_license_url|g" \
        -e "s|{{MAIN_BRANCH}}|$project_main_branch|g" \
        -e "s|{{CURRENT_YEAR}}|$(date +%Y)|g" \
        -e "s|{{CONTRIBUTING_PATH}}|$links_contributing|g" \
        -e "s|{{COC_PATH}}|$links_code_of_conduct|g" \
        -e "s|{{SECURITY_PATH}}|$links_security|g" \
        -e "s|{{SUPPORT_PATH}}|$links_support|g" \
        -e "s|{{CHANGELOG_PATH}}|$links_changelog|g" \
        -e "s|{{LICENSE_PATH}}|$links_license|g" \
        "$file"
    rm "${file}.bak"
done

echo "Template setup completed successfully!"
