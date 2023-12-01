# The-PowerQL - Interactive GraphQL Query

This is an interactive bash script that works with the GitHub GraphQL API. It's goal is to help you interact with GitHub GraphQL API's. Additional queires can be formulated and ran directly as JSON formatted strings. 

## Usage

```bash
./run_interactive.sh
```

or

```bash
./graphql_query.sh graphql_query.json
```

## Prerequisites

- Make sure you have set the required GitHub API token in the `TOKEN` environment variable. Example: `export TOKEN=ghp_****`

## Query Template Variables

The script prompts for variables in the query template. It identifies variables by using the `__VARIABLE_NAME__` format within the query template. When running the script, it will prompt for values for these variables interactively.

## Response

The script sends the GraphQL query to the GitHub API and displays the result. 

Some queires can ```POST``` for example ```04_add_reaction_issueId.json```.

Note: If no valid results are found for the GraphQL query, it will display a corresponding message.

## Reference
> https://docs.github.com/en/graphql/guides/forming-calls-with-graphql
> >
> https://docs.github.com/en/graphql/overview/about-the-graphql-api

## Note

This is a very early work-in-progress project. The design, functioanlity, the way I do documentation -- all likely to change over time. 

### Inspired by [gm3dmo/the-power](https://github.com/gm3dmo/the-power)- A simple test framework for GitHub's API's.

Rev:002
