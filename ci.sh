#!/bin/bash

# Pull the latest changes from the 'stage' branch and redirect output to log.txt
git pull origin stage >> /home/mikey/testci/log.txt 2>&1
git checkout stage >> /home/mikey/testci/log.txt

# Get the version from package.json and append it to log.txt
version=$(jq -r '.version' package.json)
echo "Version: $version" >> /home/mikey/testci/log.txt

# Get the last commit SHA from the 'develop' branch and append it to log.txt
commit_sha=$(git log -n 1 --pretty=format:"%H" develop | cut -c1-7)
echo "Commit SHA: $commit_sha" >> /home/mikey/testci/log.txt

build="$version-$commit_sha"

# Change the image of the docker-compose service to the new one
yq e '.services.app.image = "$build"' -i /home/mikey/testci/docker-compose.yml >> /home/mikey/testci/log.txt 2>&1

# Build the Docker image and append the output to log.txt
docker build -t "$build" /home/mikey/testci/ >> /home/mikey/testci/log.txt 2>&1

# Running the docker-compose with the new image
docker-compose up -d >> /home/mikey/testci/log.txt 2>&1
