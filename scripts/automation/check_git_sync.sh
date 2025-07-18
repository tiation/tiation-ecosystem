#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Git Repository Sync Status Check ===${NC}"
echo ""

# Find all git repositories
repos=$(find /Users/tiaastor/tiation-github -type d -name ".git" -maxdepth 2 | sed 's|/.git$||' | sort)

total_repos=0
synced_repos=0
ahead_repos=0
behind_repos=0
diverged_repos=0
no_remote_repos=0

while IFS= read -r repo; do
    if [ -z "$repo" ]; then
        continue
    fi
    
    total_repos=$((total_repos + 1))
    repo_name=$(basename "$repo")
    
    cd "$repo" || continue
    
    # Check if repo has a remote
    if ! git remote get-url origin > /dev/null 2>&1; then
        echo -e "${YELLOW}[$repo_name]${NC} No remote origin configured"
        no_remote_repos=$((no_remote_repos + 1))
        continue
    fi
    
    # Fetch latest from remote
    git fetch origin > /dev/null 2>&1
    
    # Get current branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    # Check if remote branch exists
    if ! git rev-parse --verify origin/"$current_branch" > /dev/null 2>&1; then
        echo -e "${YELLOW}[$repo_name]${NC} Branch '$current_branch' doesn't exist on remote"
        continue
    fi
    
    # Compare local with remote
    local_commit=$(git rev-parse HEAD)
    remote_commit=$(git rev-parse origin/"$current_branch")
    
    if [ "$local_commit" = "$remote_commit" ]; then
        echo -e "${GREEN}[$repo_name]${NC} ✓ Synced with remote"
        synced_repos=$((synced_repos + 1))
    else
        # Check if we're ahead, behind, or diverged
        ahead=$(git rev-list --count HEAD..origin/"$current_branch")
        behind=$(git rev-list --count origin/"$current_branch"..HEAD)
        
        if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
            echo -e "${RED}[$repo_name]${NC} ↕ Diverged ($behind ahead, $ahead behind)"
            diverged_repos=$((diverged_repos + 1))
        elif [ "$behind" -gt 0 ]; then
            echo -e "${YELLOW}[$repo_name]${NC} ↑ $behind commits ahead of remote"
            ahead_repos=$((ahead_repos + 1))
        elif [ "$ahead" -gt 0 ]; then
            echo -e "${YELLOW}[$repo_name]${NC} ↓ $ahead commits behind remote"
            behind_repos=$((behind_repos + 1))
        fi
    fi
    
done <<< "$repos"

echo ""
echo -e "${BLUE}=== Summary ===${NC}"
echo "Total repositories: $total_repos"
echo -e "${GREEN}Synced: $synced_repos${NC}"
echo -e "${YELLOW}Ahead of remote: $ahead_repos${NC}"
echo -e "${YELLOW}Behind remote: $behind_repos${NC}"
echo -e "${RED}Diverged: $diverged_repos${NC}"
echo -e "${YELLOW}No remote: $no_remote_repos${NC}"
