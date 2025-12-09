#!/bin/bash

SOURCE="$HOME/"
DEST="$HOME/mnt/Cloud-Reto/Backup-Captiva/"

rsync -avh --delete --no-links \
  --size-only \
  --no-perms \
  --no-times \
  --omit-dir-times \
  --exclude="mnt/" \
  --exclude="Downloads/" \
  --exclude="backup/" \
  --exclude="src/" \
  --exclude=".*" \
  --include=".config/***" \
  --include=".local/***" \
  --include=".bashrc" \
  --include=".bash_profile" \
  --include=".profile" \
  --include=".zshrc" \
  --exclude="**/node_modules/" \
  --exclude="**/target/" \
  --exclude="**/.venv/" \
  "$SOURCE" \
  "$DEST"

echo "Sync complete!"
