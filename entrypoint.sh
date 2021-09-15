#!/bin/sh -l

set -e

: "${WPENGINE_ENVIRONMENT_NAME?Required environment name variable not set.}"
: "${WPENGINE_SSH_KEY_PRIVATE?Required secret not set.}"
: "${WPENGINE_SSH_KEY_PUBLIC?Required secret not set.}"

SSH_PATH="$HOME/.ssh"
WPENGINE_HOST="git.wpengine.com"
KNOWN_HOSTS_PATH="$SSH_PATH/known_hosts"
WPENGINE_SSH_KEY_PRIVATE_PATH="$SSH_PATH/id_rsa"
WPENGINE_SSH_KEY_PUBLIC_PATH="$SSH_PATH/id_rsa.pub"
WPENGINE_ENVIRONMENT_DEFAULT="production"
WPENGINE_ENV=${WPENGINE_ENVIRONMENT:-$WPENGINE_ENVIRONMENT_DEFAULT}
ROOT_DIR_DEFAULT="."
ROOT_DIR=${ROOT_DIR:-$ROOT_DIR_DEFAULT}

mkdir "$SSH_PATH"

echo "$WPENGINE_SSH_KEY_PRIVATE" > "$WPENGINE_SSH_KEY_PRIVATE_PATH"
echo "$WPENGINE_SSH_KEY_PUBLIC" > "$WPENGINE_SSH_KEY_PUBLIC_PATH"
touch "$KNOWN_HOSTS_PATH"

chmod 700 "$SSH_PATH"
chmod 644 "$KNOWN_HOSTS_PATH"
chmod 600 "$WPENGINE_SSH_KEY_PRIVATE_PATH"
chmod 644 "$WPENGINE_SSH_KEY_PUBLIC_PATH"

ssh -i $WPENGINE_SSH_KEY_PRIVATE_PATH -o UserKnownHostsFile=$KNOWN_HOSTS_PATH -o StrictHostKeyChecking=no git@$WPENGINE_HOST

git config --global user.email "github@forwardslashny.com"
git config --global user.name "GitHub"
git config --global init.defaultBranch master
git config core.sshCommand "ssh -i $WPENGINE_SSH_KEY_PRIVATE_PATH -o UserKnownHostsFile=$KNOWN_HOSTS_PATH"
rm -rf .git
cd "$ROOT_DIR"
git init
git add .
git commit -m "GitHub Deployment" || true
git remote add origin git@$WPENGINE_HOST:$WPENGINE_ENV/$WPENGINE_ENVIRONMENT_NAME.git
git push --force --set-upstream origin master
