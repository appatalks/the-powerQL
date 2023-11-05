#!/bin/bash
#
# Author: AppaTalks
# Description: Interactive Bash wrapper for running pre-defined GitHub GraphQL queries

# Define the log file path
log_file="/tmp/graphql_interactive-$(date +'%Y%m%d-%H%M%S').json"

# Define an array with available choices in order
choices=(
  "Login Check"
  "Review Closed Issues - Owner Repo"
  "Get ID of Repo - Owner Repo"
  "Find Issue ID - Owner Repo"
  "Add Reaction to Issue"
  "Add Comment to Issue"
  "List Organization Members"
  "Get Repository IDs - Orginization"
  "Check User Rate Limits"
  "List Repository Languages - Orginization"
  "Review Branch Protection Rules - Owner Repo"
  "Review Branch Protection Rules for Pull Request - Owner Repo"
  "Check Repo Disk Usage - Owner Repo"
)

while true; do
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
    echo ""
    # Log the results to the log file
    echo -e "$QRESULTS" >> "$log_file"    
  else
    echo -e "\e[91mInvalid choice. Please select a valid number.\e[0m"
    continue
  fi

  # Ask the user if they want to run another query
  read -p "Do you want to run another query? (y)es/(n)o): " run_again
  echo ""
  if [ "$run_again" != "y" ]; then
    break
  fi
done
