#!/bin/bash
#
# Convert the JSON format back to GraphQL so that you can use this with other tools
#
# Usage: script.sh json_file.json

# Function to convert JSON to GraphQL syntax
convert_to_graphql() {
    local file=$1
    # jq -r '.query' "$file" | jq -r . | sed 's/\\n/\n/g' | sed 's/\\t/\t/g'
    jq -r '.query' "$file" 
}

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install it."
    exit 1
fi

# Check if a file was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 json_file.json"
    exit 1
fi

# Convert the provided JSON file
convert_to_graphql "$1"

