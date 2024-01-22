#!/bin/bash

# Prompt user for Dockerfile path
read -p "Enter the path to your Dockerfile: " DOCKERFILE_PATH

# Check if the provided Dockerfile path exists
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Error: The specified Dockerfile does not exist."
    exit 1
fi

# Prompt user for GitHub token
read -p "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" GITHUB_TOKEN

# Replace these values with your GitHub repository information
REPO_NAME="your_github_repo_name"
BRANCH_NAME="main"

# Build Docker image
IMAGE_TAG="my-docker-image:latest"
docker build -t $IMAGE_TAG -f $DOCKERFILE_PATH .

git add $DOCKERFILE_PATH
git commit -m "Update Dockerfile"
git pull origin $BRANCH_NAME --rebase
git push origin $BRANCH_NAME

echo "Changes pushed to GitHub on branch '$BRANCH_NAME'."
