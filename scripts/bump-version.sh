#!/bin/bash

if [ -z "$1" ]; then
  echo "Użycie: ./bump-version.sh <nowa_wersja> (np. ./bump-version.sh 0.1.2)"
  exit 1
fi

NEW_VERSION=$1
echo "Podnoszenie wersji do $NEW_VERSION..."

# Aktualizacja package.json za pomocą npm
npm version $NEW_VERSION --no-git-tag-version

# Aktualizacja w tauri.conf.json
sed -i "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" src-tauri/tauri.conf.json

# Aktualizacja w Cargo.toml
sed -i "s/^version = \".*\"/version = \"$NEW_VERSION\"/" src-tauri/Cargo.toml

# Aktualizacja w snapcraft.yaml
sed -i "s/^version: '.*'/version: '$NEW_VERSION'/" snap/snapcraft.yaml

# Aktualizacja plików lock (package-lock.json i Cargo.lock)
echo "Aktualizowanie plików lock..."
npm install --package-lock-only
cd src-tauri && cargo update -p pro-simple-timer
cd ..

echo "Gotowe! Sprawdź zmiany za pomocą 'git diff'."
