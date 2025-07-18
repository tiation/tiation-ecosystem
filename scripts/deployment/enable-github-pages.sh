#!/bin/bash

# Enable GitHub Pages for all Tiation repositories
# This script provides instructions for enabling GitHub Pages via GitHub CLI or web interface

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Define repositories
declare -a REPOS=(
    "tiation-terminal-workflows"
    "tiation-docker-debian"
    "tiation-automation-workspace"
    "tiation-ai-platform"
    "tiation-ai-agents"
    "tiation-rigger-workspace-docs"
    "tiation-macos-networking-guide"
    "tiation-go-sdk"
    "tiation-python-sdk"
    "tiation-js-sdk"
    "tiation-java-sdk"
    "tiation-ai-code-assistant"
    "tiation-private-ai-chat"
    "tiation-cms"
    "tiation-github-pages-theme"
    "ubuntu-dev-setup"
    "tiation-secure-vpn"
    "tiation-rigger-connect-api"
    "tiation-infrastructure-charms"
    "tiation-knowledge-base-ai"
)

echo -e "${CYAN}🌐 GitHub Pages Enablement Guide${NC}"
echo -e "${YELLOW}This script helps enable GitHub Pages for all your repositories${NC}"
echo ""

# Check if GitHub CLI is available
if command -v gh &> /dev/null; then
    echo -e "${GREEN}✅ GitHub CLI detected${NC}"
    echo -e "${BLUE}📋 You can enable GitHub Pages using GitHub CLI:${NC}"
    echo ""
    
    for repo in "${REPOS[@]}"; do
        echo -e "${PURPLE}# Enable GitHub Pages for ${repo}${NC}"
        echo "gh repo edit tiation/${repo} --enable-pages --pages-branch main --pages-path /promotional"
        echo ""
    done
    
    echo -e "${YELLOW}💡 Run the above commands to enable GitHub Pages automatically${NC}"
else
    echo -e "${YELLOW}⚠️ GitHub CLI not found${NC}"
    echo -e "${BLUE}📋 Manual GitHub Pages enablement instructions:${NC}"
    echo ""
    echo "1. Go to each repository on GitHub:"
    echo ""
    
    for repo in "${REPOS[@]}"; do
        echo "   https://github.com/tiation/${repo}/settings/pages"
    done
    
    echo ""
    echo "2. For each repository:"
    echo "   - Go to Settings → Pages"
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: main (or master)"
    echo "   - Folder: /promotional"
    echo "   - Click Save"
    echo ""
fi

echo -e "${CYAN}📊 Repository URLs after GitHub Pages is enabled:${NC}"
echo ""

for repo in "${REPOS[@]}"; do
    echo "🌐 ${repo}: https://tiation.github.io/${repo}/"
done

echo ""
echo -e "${GREEN}🎉 All repositories will have their promotional sites live on GitHub Pages!${NC}"
