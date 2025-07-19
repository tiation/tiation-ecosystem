#!/bin/bash

# Tiation GitHub Repositories Sync Script
# This script clones/syncs all repositories from the tiation GitHub account

TIATION_DIR="$HOME/tiation-github"
LOG_FILE="$TIATION_DIR/sync.log"

# Create log file
echo "=== Tiation GitHub Sync - $(date) ===" >> "$LOG_FILE"

# List of all tiation repositories
REPOS=(
    "https://github.com/tiation/19-trillion-solution.git"
    "https://github.com/tiation/ad-setup.git"
    "https://github.com/tiation/afl-fantasy-manager-docs.git"
    "https://github.com/tiation/AgentGPT.git"
    "https://github.com/tiation/AlmaStreet.git"
    "https://github.com/tiation/awesome-decentralized-autonomous-organizations.git"
    "https://github.com/tiation/awsmarketplace.git"
    "https://github.com/tiation/cargo-diff-tools.git"
    "https://github.com/tiation/Case_Study_Legal.git"
    "https://github.com/tiation/charms.git"
    "https://github.com/tiation/ChaseWhiteRabbit.git"
    "https://github.com/tiation/claude-desktop-debian.git"
    "https://github.com/tiation/company-intranet.git"
    "https://github.com/tiation/Computer-Science-Textbooks.git"
    "https://github.com/tiation/core-foundation-rs.git"
    "https://github.com/tiation/developer.git"
    "https://github.com/tiation/DiceRollerSimulator.git"
    "https://github.com/tiation/difflib.git"
    "https://github.com/tiation/dnd_dice_roller.git"
    "https://github.com/tiation/dockerdeb.git"
    "https://github.com/tiation/dontbeacunt.git"
    "https://github.com/tiation/dotfiles.git"
    "https://github.com/tiation/FastGPT.git"
    "https://github.com/tiation/flutter-intl-vscode.git"
    "https://github.com/tiation/fpl-ai.git"
    "https://github.com/tiation/GetDataSmush.git"
    "https://github.com/tiation/git-workspace.git"
    "https://github.com/tiation/go-project-template.git"
    "https://github.com/tiation/grieftodesign.git"
    "https://github.com/tiation/headscale-admin.git"
    "https://github.com/tiation/home.git"
    "https://github.com/tiation/huggingface-llama-recipes.git"
    "https://github.com/tiation/indicator_part_2.git"
    "https://github.com/tiation/Intermap.git"
    "https://github.com/tiation/lappy.git"
    "https://github.com/tiation/m4.git"
    "https://github.com/tiation/mac-zsh-completions.git"
    "https://github.com/tiation/mkusb.git"
    "https://github.com/tiation/open-webui.git"
    "https://github.com/tiation/oss-trunk-linter-config.git"
    "https://github.com/tiation/Parrot-Security-Guide.git"
    "https://github.com/tiation/payload.git"
    "https://github.com/tiation/pop.git"
    "https://github.com/tiation/pop-os-25.git"
    "https://github.com/tiation/privateGPT.git"
    "https://github.com/tiation/ProtectChildrenAustralia.git"
    "https://github.com/tiation/quick.git"
    "https://github.com/tiation/riggerconnect.git"
    "https://github.com/tiation/RiggerConnect-RiggerJobs-Workspace-PB.git"
    "https://github.com/tiation/RiggerConnectRiggerHubApp.git"
    "https://github.com/tiation/Roo-Cline.git"
    "https://github.com/tiation/rust-embed.git"
    "https://github.com/tiation/server-configs-gae.git"
    "https://github.com/tiation/smol-dev-js.git"
    "https://github.com/tiation/source-code-pro.git"
    "https://github.com/tiation/SuperCoder.git"
    "https://github.com/tiation/tiation.git"
    "https://github.com/tiation/tokio.git"
    "https://github.com/tiation/ubuntu-dev-setup.git"
    "https://github.com/tiation/uneval.git"
    "https://github.com/tiation/vmware-host-modules-builder-cli.git"
    "https://github.com/tiation/vscode.git"
    "https://github.com/tiation/vscodeoffline.git"
    "https://github.com/tiation/vuit.git"
    "https://github.com/tiation/windows-dev-setup.git"
    "https://github.com/tiation/workflows.git"
)

# Function to clone all repositories
clone_all() {
    echo "Cloning all tiation repositories..."
    cd "$TIATION_DIR" || exit
    
    for repo in "${REPOS[@]}"; do
        repo_name=$(basename "$repo" .git)
        echo "Processing: $repo_name"
        
        if [ -d "$repo_name" ]; then
            echo "  → Already exists, skipping clone"
        else
            echo "  → Cloning..."
            git clone "$repo" "$repo_name"
        fi
    done
}

# Function to update all repositories
update_all() {
    echo "Updating all repositories..."
    cd "$TIATION_DIR" || exit
    
    for repo in "${REPOS[@]}"; do
        repo_name=$(basename "$repo" .git)
        if [ -d "$repo_name" ]; then
            echo "Updating: $repo_name"
            cd "$repo_name" || continue
            git fetch --all
            git pull --ff-only
            cd ..
        fi
    done
}

# Function to list all repositories
list_repos() {
    echo "Tiation repositories:"
    for repo in "${REPOS[@]}"; do
        repo_name=$(basename "$repo" .git)
        if [ -d "$TIATION_DIR/$repo_name" ]; then
            echo "  ✓ $repo_name (synced)"
        else
            echo "  ✗ $repo_name (not synced)"
        fi
    done
}

# Function to show status of all repositories
status_all() {
    echo "Repository status:"
    cd "$TIATION_DIR" || exit
    
    for repo in "${REPOS[@]}"; do
        repo_name=$(basename "$repo" .git)
        if [ -d "$repo_name" ]; then
            cd "$repo_name" || continue
            echo "=== $repo_name ==="
            git status --porcelain
            echo ""
            cd ..
        fi
    done
}

# Main script logic
case "$1" in
    "clone")
        clone_all
        ;;
    "update")
        update_all
        ;;
    "list")
        list_repos
        ;;
    "status")
        status_all
        ;;
    *)
        echo "Usage: $0 {clone|update|list|status}"
        echo "  clone  - Clone all repositories"
        echo "  update - Update all existing repositories"
        echo "  list   - List all repositories and sync status"
        echo "  status - Show git status for all repositories"
        ;;
esac
