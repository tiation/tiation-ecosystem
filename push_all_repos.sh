#!/bin/bash

# Script to push all changes for all repositories to remote GitHub
# This script will iterate through all git repositories and push any uncommitted changes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counter for repositories processed
total_repos=0
repos_with_changes=0
repos_pushed=0
repos_failed=0

echo -e "${BLUE}🚀 Starting mass push for all repositories...${NC}"
echo "================================================="

# Find all git repositories
while IFS= read -r -d '' repo_path; do
    repo_dir=$(dirname "$repo_path")
    repo_name=$(basename "$repo_dir")
    
    echo -e "\n${YELLOW}📁 Processing: $repo_name${NC}"
    echo "   Path: $repo_dir"
    
    cd "$repo_dir"
    total_repos=$((total_repos + 1))
    
    # Check if there are any changes (staged, unstaged, or untracked)
    if ! git diff --quiet HEAD -- 2>/dev/null || ! git diff --cached --quiet 2>/dev/null || [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
        repos_with_changes=$((repos_with_changes + 1))
        echo -e "   ${GREEN}✓ Changes detected${NC}"
        
        # Add all changes
        git add -A
        
        # Check if there are staged changes after adding
        if ! git diff --cached --quiet 2>/dev/null; then
            # Generate commit message based on changes
            current_date=$(date '+%Y-%m-%d %H:%M:%S')
            commit_message="Auto-commit: Updates and improvements - $current_date"
            
            # Commit changes
            git commit -m "$commit_message"
            echo -e "   ${GREEN}✓ Committed changes${NC}"
            
            # Push to remote
            if git push origin HEAD 2>/dev/null; then
                repos_pushed=$((repos_pushed + 1))
                echo -e "   ${GREEN}✓ Successfully pushed to remote${NC}"
            else
                repos_failed=$((repos_failed + 1))
                echo -e "   ${RED}✗ Failed to push to remote${NC}"
            fi
        else
            echo -e "   ${YELLOW}⚠ No changes to commit after staging${NC}"
        fi
    else
        echo -e "   ${BLUE}ℹ No changes detected${NC}"
    fi
    
done < <(find /Users/tiaastor/tiation-github -name ".git" -type d -print0)

echo -e "\n${BLUE}=================================================${NC}"
echo -e "${BLUE}📊 Summary:${NC}"
echo -e "   Total repositories processed: $total_repos"
echo -e "   Repositories with changes: $repos_with_changes"
echo -e "   Repositories successfully pushed: $repos_pushed"
echo -e "   Repositories failed to push: $repos_failed"

if [ $repos_pushed -gt 0 ]; then
    echo -e "\n${GREEN}🎉 Successfully pushed changes for $repos_pushed repositories!${NC}"
fi

if [ $repos_failed -gt 0 ]; then
    echo -e "\n${RED}⚠ $repos_failed repositories failed to push. Please check them manually.${NC}"
fi

echo -e "\n${BLUE}✨ Mass push operation completed!${NC}"
