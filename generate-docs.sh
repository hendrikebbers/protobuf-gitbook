#!/bin/bash

docker run --rm \
  -v $(pwd)/docs:/out \
  -v $(pwd)/protos-2/services:/protos \
   -v $(pwd)/template:/template \
  pseudomuto/protoc-gen-doc --doc_opt=/template/template.mustache,doc.txt

INPUT_FILE="docs/doc.txt"      # Input file name
OUTPUT_DIR="docs/markdown"      # Output directory

# Create output dir if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Read the input line by line
inside_block=false
filename=""
content=""

while IFS= read -r line; do
  if [[ $line =~ ^-----\ START\ OF\ (.+)\ -----$ ]]; then
    proto_name="${BASH_REMATCH[1]}"
    filename="${OUTPUT_DIR}/${proto_name}.md"
    content=""
    inside_block=true
  elif [[ $line =~ ^-----\ END\ OF\ (.+)\ -----$ ]]; then
    if [ "$inside_block" = true ]; then
      echo -e "$content" > "$filename"
      echo "✅ Created: $filename"
      inside_block=false
    fi
  elif [ "$inside_block" = true ]; then
    content+="$line"$'\n'
  fi
done < "$INPUT_FILE"