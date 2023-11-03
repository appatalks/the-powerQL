# Example Usage:
# ./codeql_query.sh graphpql_query.json
curl -s -H "Authorization: bearer $TOKEN" -X POST -d @$1 https://api.github.com/graphql | jq
