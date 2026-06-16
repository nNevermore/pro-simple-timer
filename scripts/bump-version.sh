#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./bump-version.sh <new_version> (e.g. ./bump-version.sh 0.1.2)"
  exit 1
fi

NEW_VERSION=$1
echo "Bumping version to $NEW_VERSION..."

# Update package.json using npm
npm version $NEW_VERSION --no-git-tag-version

# Update tauri.conf.json
sed -i "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" src-tauri/tauri.conf.json

# Update Cargo.toml
sed -i "s/^version = \".*\"/version = \"$NEW_VERSION\"/" src-tauri/Cargo.toml

# Update snapcraft.yaml
sed -i "s/^version: '.*'/version: '$NEW_VERSION'/" snap/snapcraft.yaml

# Update lock files (package-lock.json and Cargo.lock)
echo "Updating lock files..."
npm install --package-lock-only
cd src-tauri && cargo update -p pro-simple-timer
cd ..

echo "Done! Check your changes using 'git diff'."
