#!/bin/bash
# Install typos-cli for spell checking

set -e

echo "Installing typos-cli..."

# Check if cargo is installed
if ! command -v cargo >/dev/null 2>&1; then
    echo "Cargo not found. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Install typos-cli
if ! command -v typos >/dev/null 2>&1; then
    cargo install typos-cli
    echo "✓ typos-cli installed successfully"
else
    echo "✓ typos-cli is already installed"
fi

# Verify installation
typos --version
