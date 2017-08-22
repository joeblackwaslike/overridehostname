#!/usr/bin/env bash

REMOTE=${1:-origin}

CURRENT_TAG=$(git tag | sort -n | tail -1)

CURRENT_MAJOR=$(echo $CURRENT_TAG | cut -d'.' -f1)
CURRENT_MINOR=$(echo $CURRENT_TAG | cut -d'.' -f2)

NEXT_MINOR=$(expr $CURRENT_MINOR + 1)
NEXT_TAG="${CURRENT_MAJOR}.${CURRENT_MINOR}"


echo "Incrementing version $CURRENT_TAG > $NEXT_TAG ..."
git tag $NEXT_TAG

echo "Pushing to github remote: $REMOTE ..."
git push $REMOTE master --tags
