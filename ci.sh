#!/bin/bash

# Pull the latest changes from the 'stage' branch and redirect output to log.txt
git pull origin stage >> log.txt 2>&1

# Get the version from package.json and append it to log.txt
version=$(jq -r '.version' package.json)
echo "Version: $version" >> log.txt

# Get the last commit SHA from the 'develop' branch and append it to log.txt
commit_sha=$(git log -n 1 --pretty=format:"%H" develop | cut -c1-7)
echo "Commit SHA: $commit_sha" >> log.txt

# Build the Docker image and append the output to log.txt
docker build -t "$version-$commit_sha" . >> log.txt 2>&1
