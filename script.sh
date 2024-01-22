#!/bin/bash

# Prompt user for Dockerfile path
read -p "Enter the path to your Dockerfile: " DOCKERFILE_PATH

# Check if the provided Dockerfile path exists
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Error: The specified Dockerfile does not exist."
    exit 1
fi

# Prompt user for GitHub token
read -p "Enter your GitHub token: " GITHUB_TOKEN

# Replace these values with your GitHub repository information
REPO_NAME="your_github_repo_name"
BRANCH_NAME="main"

# Build Docker image
IMAGE_TAG="my-docker-image:latest"
docker build -t $IMAGE_TAG -f $DOCKERFILE_PATH .

# Check if there are changes that need to be committed
if [ -n "$(git status --porcelain)" ]; then
    # Prompt user to either commit or stash changes
    read -p "You have unstaged changes. Do you want to commit them? (y/n): " COMMIT_CHANGES

    if [ "$COMMIT_CHANGES" == "y" ]; then
        # Prompt user for commit message
        read -p "Enter a commit message: " COMMIT_MESSAGE

        # Add, commit, and push changes to GitHub
        git add $DOCKERFILE_PATH
        git commit -m "$COMMIT_MESSAGE"
    elif [ "$COMMIT_CHANGES" == "n" ]; then
        # Stash changes
        git stash
    else
        echo "Invalid option. Aborting."
        exit 1
    fi
fi

# Pull changes from GitHub
git pull origin $BRANCH_NAME --rebase

# Push changes to GitHub
git push origin $BRANCH_NAME

echo "Changes pushed to GitHub on branch '$BRANCH_NAME'."
