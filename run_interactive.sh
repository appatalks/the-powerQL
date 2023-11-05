#!/bin/bash

# Define an array with available choices in order
choices=(
  "Login Check"
  "Review Closed Issues"
  "Review Branch Protection Rules"
  "Find Issue ID"
  "Add Reaction to Issue"
  "Add Comment to Issue"
  "List Organization Members"
  "Get Org Repository IDs"
  "Check User Rate Limits"
  "List Org Repository Languages"
  "Get User Repository ID"
)

# Prompt the user for their choice
echo "Please select a GraphQL query (enter the corresponding number):"
for ((i=0; i<${#choices[@]}; i++)); do
  echo "$i) ${choices[$i]}"
done
echo ""

read -p "Your choice: " user_choice
echo ""

# Check if the user's choice is valid
if [[ "$user_choice" =~ ^[0-9]+$ ]] && [ "$user_choice" -ge 0 ] && [ "$user_choice" -lt ${#choices[@]} ]; then
  query_file="$(printf "%02d" $user_choice)_*.json"
  QRESULTS=$(./graphql_query.sh json/$query_file)
  echo -e "$QRESULTS" | sed 's/["{}]//g' | sed '/^\s*$/d' | sed 's/,//g' 

else
  echo "\e[91mInvalid choice. Please select a valid number.\e[0m"
fi

