#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Find the highest version tag
TAG=$(git tag --sort=-version:refname | head -n 1)

if [[ -z "$TAG" ]]; then
    echo "Error: No tags found."
    exit 1
fi

# Package the addon at that tag
ZIP="dist/draw3d-${TAG}.zip"

if [[ -e "$ZIP" ]]; then
    echo "Error: $ZIP already exists."
    exit 1
fi

git archive --format=zip --output="$ZIP" "$TAG" addons/

echo "Created $ZIP"
