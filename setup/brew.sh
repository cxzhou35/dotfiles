#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUNDLE_FILE="$ROOT_DIR/setup/homebrew_install_list.txt"

STATUS=$(which brew)

if [ -z "$STATUS" ]; then
	echo "[INFO]Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "[INFO]Homebrew is already installed..."
fi

echo "[INFO]Installing homebrew packages..."

echo "[INFO]Using bundle file: $BUNDLE_FILE"
brew bundle --file="$BUNDLE_FILE"

exit 0
