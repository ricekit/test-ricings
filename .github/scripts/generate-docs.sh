#!/bin/bash

# Script to extract function names and their top comments from commands.sh
# Usage: ./generate-docs.sh [input_dir]
# Default: ./generate-docs.sh profile.d

INPUT_DIR="${1:-profile.d}"

# Check if input directory exists
if [[ ! -d "$INPUT_DIR" ]]; then
    echo "Error: Input directory '$INPUT_DIR' not found"
    exit 1
fi

# Generate documentation header if README.head exists, otherwise create basic header
if [[ -f "README.head" ]]; then
    cat README.head > README.md
fi

echo "" >> README.md
echo "## Modules provided" >> README.md
echo "" >> README.md
mkdir -p docs

for INPUT_FILE in "$INPUT_DIR"/*.sh; do
    MODULE_NAME=$(basename "$INPUT_FILE" .sh)
    OUTPUT_FILE="docs/${MODULE_NAME}.md"

    echo "* [${MODULE_NAME}](${OUTPUT_FILE})" >> README.md
    
    # Extract module description (first comment block)
    # Then extract functions and their comments
    awk -f .github/scripts/generate-docs.awk "$INPUT_FILE" > "$OUTPUT_FILE"
done

if [[ -f README.tail ]]; then
    cat README.tail >> "$OUTPUT_FILE"
fi

echo "Documentation generated: $OUTPUT_FILE"
