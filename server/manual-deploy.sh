#!/bin/bash

# --- CONFIGURATION ---

# Local path to your NixOS config
LOCAL_REPO_DIR="."

# Remote machine SSH info
REMOTE_USER="deployer"
REMOTE_HOST="192.168.8.58" # example: 192.168.1.10 or serveur-loic.example.com

# Remote path where to sync the config
REMOTE_REPO_DIR="/home/$REMOTE_USER/nixos-config"

# --- SYNC FILES ---

echo "Syncing local repo to remote server..."

rsync -avz --delete "$LOCAL_REPO_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_REPO_DIR/" || {
  echo "❌ Rsync failed"; exit 1;
}

# --- GENERATE HARDWARE ---

echo "Regenerating Hardware configuration"

ssh "$REMOTE_USER@$REMOTE_HOST" "
  nixos-generate-config --dir $REMOTE_REPO_DIR
" || {
  echo "❌ Remote regeneration failed"; exit 1;
}

echo "✅ Remote NixOS hardware configuration regenerated"

# --- REMOTE REBUILD ---

echo "Rebuilding NixOS configuration on remote server..."

ssh "$REMOTE_USER@$REMOTE_HOST" "
  sudo nixos-rebuild switch --flake '$REMOTE_REPO_DIR#serveur-loic'
" || {
  echo "❌ Remote rebuild failed"; exit 1;
}

echo "✅ Remote NixOS system rebuilt successfully."