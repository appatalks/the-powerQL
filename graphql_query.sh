#!/bin/bash
#
# Example Usage:
# ./graphql_query.sh graphpql_query.json

# Check if the required GitHub API token is set
if [ -z "$TOKEN" ]; then
  echo "Error: Please set the GitHub API token in the TOKEN environment variable."
  echo "Example: $ export TOKEN=ghp_****"
  exit 1
fi

# Check if a query file is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <query_file>"
  exit 1
fi

# Set the query file from the command-line argument
QUERY_FILE="$1"

# Function to extract and prompt for variables in the query template
extract_and_prompt_variables() {
  local template="$1"
  local extracted_variables=()
  while [[ $template =~ __([A-Z_]+)__ ]]; do
    variable_name="${BASH_REMATCH[1]}"
    if [[ ! " ${extracted_variables[@]} " =~ " ${variable_name} " ]]; then
      read -p "Enter value for $variable_name: " value
      template=${template//__${variable_name}__/$value}
      extracted_variables+=("$variable_name")
    fi
  done
  echo "$template"
}

# Check if the query file exists
if [ ! -f "$QUERY_FILE" ]; then
  echo -e "\e[91mError: The specified query file ($QUERY_FILE) does not exist.\e[0m"
  exit 1
fi

# Read the contents of the query file
QUERY_TEMPLATE=$(<"$QUERY_FILE")

# Extract and prompt for variables in the query template
QUERY_TEMPLATE=$(extract_and_prompt_variables "$QUERY_TEMPLATE")

# echo $QUERY_TEMPLATE
echo ""

# Send the GraphQL query to the GitHub API
response=$(curl -s -H "Authorization: bearer $TOKEN" -X POST -d "$QUERY_TEMPLATE" https://api.github.com/graphql)

log_query=$(echo $QUERY_TEMPLATE)
echo -e "\n\e[32mQuery: \e[0m" >> "$log_file"
echo -e "$log_query\n" >> "$log_file"


# Check if the response contains the "data" field and "errors" field
if echo "$response" | jq '.data,.errors' &> /dev/null; then
  data_response=$(echo "$response" | jq '.data')
  errors_response=$(echo "$response" | jq '.errors')

  # echo $data_response
  # echo $errors_response

  if [ "$data_response" != '{
  "repository": null
}' ]; then
    echo -e "\e[32mGraphQL query result (Data):\e[0m"
    echo -e "" 
    echo "$data_response" | jq
  else
    echo -e "\e[91mNo valid results found for the GraphQL query.\e[0m"
    echo ""
  fi

  if [ "$errors_response" != "null" ]; then
    echo "\n "	  
    echo -e "\e[91mGraphQL query result (Errors):\e[0m"
    echo -e ""
    echo "$errors_response" | jq
  fi
fi
