#!/bin/bash

# Check for required environment variables
REQUIRED_VARS=("GH_PAT" "OPENAI_API_KEY" "ISSUE_NUMBER")
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Environment variable $var is not set."
        exit 1
    fi
done

# Fetch issue details using GitHub CLI
ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json title,body,comments -t '{{.title}}|{{.body}}{{range .comments}}|{{.body}}{{end}}')

# Parse the issue data into title, body, and comments
IFS='|' read -r ISSUE_TITLE ISSUE_BODY COMMENTS <<< "$ISSUE_DATA"

# Prepare the data for OpenAI API
ISSUE_TITLE_JSON=$(jq -aRs . <<< "$ISSUE_TITLE")
ISSUE_BODY_JSON=$(jq -aRs . <<< "$ISSUE_BODY")
COMMENTS_JSON=$(jq -aRs . <<< "$COMMENTS")

# Formulate the prompt
PROMPT=$(jq -n \
    --arg issueTitle "$ISSUE_TITLE_JSON" \
    --arg issueBody "$ISSUE_BODY_JSON" \
    --arg comments "$COMMENTS_JSON" \
    '{
        prompt: ("Issue Title: " + $issueTitle + "\n\nIssue Body:\n" + $issueBody + "\n\nComments:\n" + $comments + "\n\nPlease provide a concise, efficient solution for the above github issue."),
        max_tokens: 1024,
        model: "gpt-3.5-turbo"
    }')

# Send a request to the OpenAI API using Instruct model
RESPONSE=$(curl -s "https://api.openai.com/v1/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$PROMPT"
)

# Extract the answer
ANSWER=$(echo "$RESPONSE" | jq -r .choices[0].text)

# Use GitHub CLI to comment on the issue and remove the label
echo "$GH_PAT" | gh auth login --with-token
gh issue comment "$ISSUE_NUMBER" --body "$ANSWER"
gh issue edit "$ISSUE_NUMBER" --remove-label "chatcompletion"

