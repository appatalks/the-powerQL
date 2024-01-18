#!/bin/bash
#
# Author: AppaTalks
# Description: Interactive Bash wrapper for running pre-defined GitHub GraphQL queries

# Define the log file path
log_file="/tmp/graphql_interactive-$(date +'%Y%m%d-%H%M%S').json"
export log_file=$log_file

echo "Is this dotcom or server?"
read -r environment

if [ "$environment" == "dotcom" ]; then
    # Set endpoint for GitHub.com
    ENDPOINT="https://api.github.com/graphql"
    export ENDPOINT=$ENDPOINT
elif [ "$environment" == "server" ]; then
    # Set endpoint for GitHub Enterprise
    echo "Enter the hostname for GitHub Enterprise:"
    read -r hostname
    ENDPOINT="https://$hostname/api/graphql"
    export ENDPOINT=$ENDPOINT
else
    echo "Invalid environment. Please enter 'dotcom' or 'server'."
    exit 1
fi

# Define an array with available top-level choices
top_level_choices=("GraphQL Query" "Organization Query")

# Define sub-queries for each category
graphql_queries=(
  "Login Check" 
  "Get ID of Repo"
  "Find Issue ID"
  "Review Closed Issues" 
  "Add Reaction to Issue"
  "Add Comment to Issue"
  "Check User Rate Limits"
  "Review Branch Protection Rules"
  "Review Branch Protection Rules for Pull Request"
  "Check Repo Disk Usage"
  "Check Suite ID by Pull Request"
  "Check Enterprise ID"
  "Create an Organization"
  "List Repo Objects"
  "Query Pull Request Decisions"
)
organization_queries=( 
  "List Organization Members"
  "Get Repository IDs"
  "List Repository Languages"
  "Get Project ID"
  "List Project Details"
  "Query Pull Request Decisions"
)

while true; do
  # Prompt the user for the initial choice
  echo "Please select the query type:"
  for ((i=0; i<${#top_level_choices[@]}; i++)); do
    echo "$i) ${top_level_choices[$i]}"
  done
  echo ""

  read -p "Your choice: " top_level_choice
  echo ""

  # Check if the top-level choice is valid
  if [[ "$top_level_choice" =~ ^[0-9]+$ ]] && [ "$top_level_choice" -ge 0 ] && [ "$top_level_choice" -lt ${#top_level_choices[@]} ]; then
    # Depending on the top-level choice, set the prefix for query_file
    if [ "$top_level_choice" -eq 0 ]; then
      query_file_prefix="g"
      sub_queries=("${graphql_queries[@]}")
    else
      query_file_prefix="o"
      sub_queries=("${organization_queries[@]}")
    fi

    # Prompt the user for their sub-choice (based on the top-level choice)
    echo "Please select a sub-query (enter the corresponding number):"
    for ((i=0; i<${#sub_queries[@]}; i++)); do
      echo "$i) ${sub_queries[$i]}"
    done
    echo ""

    read -p "Your sub-choice: " user_sub_choice
    echo ""

    # Check if the user's sub-choice is valid
    if [[ "$user_sub_choice" =~ ^[0-9]+$ ]] && [ "$user_sub_choice" -ge 0 ] && [ "$user_sub_choice" -lt ${#sub_queries[@]} ]; then
      query_file="$(printf "%02d" $user_sub_choice)_${query_file_prefix}_*.json"
      QRESULTS=$(./graphql_query.sh json/$query_file)
      echo -e "$QRESULTS" | sed 's/["{}]//g' | sed '/^\s*$/d' | sed 's/,//g'

      # Log the results to the log file
      echo -e "$QRESULTS" | sed 's/["{}]//g' | sed '/^\s*$/d' | sed 's/,//g' >> "$log_file"
    else
      echo -e "\e[91mInvalid sub-choice. Please select a valid number.\e[0m"
    fi
  else
    echo -e "\e[91mInvalid top-level choice. Please select a valid number.\e[0m"
    continue
  fi

  # Ask the user if they want to run another query
  read -p "Do you want to run another query? (y)es/(n)o: " run_again
  if [ "$run_again" != "y" ]; then
    echo -e "\e[32mLog File Saved to $log_file\e[0m"	  
    break
  fi
done

