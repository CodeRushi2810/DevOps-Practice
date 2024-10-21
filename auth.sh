#!/bin/bash

# Check if the right number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <client_id> <client_secret>"
    exit 1
fi

# Assign input parameters to variables
CLIENT_ID=$1
CLIENT_SECRET=$2

# Request an access token from Salesforce
ACCESS_TOKEN=$(curl -s -X POST https://login.salesforce.com/services/oauth2/token \
    -d "grant_type=client_credentials" \
    -d "client_id=${CLIENT_ID}" \
    -d "client_secret=${CLIENT_SECRET}" | jq -r '.access_token')

# Check if the token was retrieved successfully
if [ -z "$ACCESS_TOKEN" ]; then
    echo "Failed to retrieve access token."
    exit 1
fi

# Print the access token
echo $ACCESS_TOKEN
