# GraphQL Query Script

This is a bash script that works with the GitHub GraphQL API.

## Usage

```bash
./run_interactive.sh
```

## Prerequisites

- Make sure you have set the required GitHub API token in the `TOKEN` environment variable. Example: `export TOKEN=ghp_****`

## Query Template Variables

The script prompts for variables in the query template. It identifies variables by using the `__VARIABLE_NAME__` format within the query template. When running the script, it will prompt for values for these variables interactively.

## Response

The script sends the GraphQL query to the GitHub API and displays the result in JSON format. 

Some queires can ```POST``` for example ```04_add_reaction_issueId.json```.

Note: If no valid results are found for the GraphQL query, it will display a corresponding message.

## Reference
> https://docs.github.com/en/graphql/guides/forming-calls-with-graphql
> >
> https://docs.github.com/en/graphql/overview/about-the-graphql-api
