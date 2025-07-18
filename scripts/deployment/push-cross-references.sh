#!/bin/bash

# Script to commit and push cross-reference changes to all repositories

REPOS=(
    "19-trillion-solution"
    "ChaseWhiteRabbit"
    "company-intranet"
    "grieftodesign"
    "TiaAstor"
    "tiation"
    "server-configs-gae"
    "ProtectChildrenAustralia"
    "home"
    "git-workspace"
    "dontbeacunt"
    "DiceRollerSimulator"
    "core-foundation-rs"
    "Case_Study_Legal"
    "awesome-decentralized-autonomous-organizations"
    "AlmaStreet"
    "ubuntu-dev-setup"
    "windows-dev-setup"
    "workflows"
)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to commit and push changes
commit_and_push() {
    local repo=$1
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "\n${YELLOW}Processing $repo...${NC}"
    
    cd "$repo_path" || {
        echo -e "${RED}✗ Failed to change to $repo directory${NC}"
        return 1
    }
    
    # Check if there are changes
    if git diff --quiet && git diff --cached --quiet; then
        echo -e "${GREEN}✓ No changes in $repo${NC}"
        return 0
    fi
    
    # Add README.md changes
    git add README.md
    
    # Commit changes
    git commit -m "Add cross-repository references and align documentation

- Added Related Repositories section to README
- Included direct dependencies and relationships
- Added quick links to common resources
- Referenced parent Tiation ecosystem
- Part of repository alignment initiative" || {
        echo -e "${RED}✗ Failed to commit in $repo${NC}"
        return 1
    }
    
    # Push changes
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || {
        echo -e "${RED}✗ Failed to push $repo (check branch name or remote)${NC}"
        return 1
    }
    
    echo -e "${GREEN}✓ Successfully pushed changes to $repo${NC}"
    return 0
}

# Main execution
echo "Committing and pushing cross-reference changes to all repositories..."
echo "============================================================"

successful=0
failed=0
no_changes=0

for repo in "${REPOS[@]}"; do
    if [ -d "/Users/tiaastor/tiation-github/$repo" ]; then
        if commit_and_push "$repo"; then
            if git diff --quiet && git diff --cached --quiet; then
                ((no_changes++))
            else
                ((successful++))
            fi
        else
            ((failed++))
        fi
    else
        echo -e "${RED}⚠ Repository $repo not found, skipping...${NC}"
        ((failed++))
    fi
done

# Also commit and push the main index files in the parent directory
echo -e "\n${YELLOW}Processing main index files...${NC}"
cd /Users/tiaastor/tiation-github

# Check if this is a git repository
if [ -d .git ]; then
    git add REPOSITORY_INDEX.md REPOSITORY_GRAPH.md add-cross-references.sh push-cross-references.sh cross-reference-summary.md
    git commit -m "Add repository index and cross-reference system

- Created comprehensive repository index
- Added visual dependency graph
- Created scripts for cross-reference management
- Part of repository alignment initiative" || echo -e "${YELLOW}No changes to commit in main directory${NC}"
    
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo -e "${YELLOW}Could not push main directory (might not be a remote repo)${NC}"
fi

echo -e "\n============================================================"
echo -e "${GREEN}Summary:${NC}"
echo -e "  Successful pushes: ${GREEN}$successful${NC}"
echo -e "  No changes: ${YELLOW}$no_changes${NC}"
echo -e "  Failed: ${RED}$failed${NC}"
echo -e "\n${GREEN}Cross-reference update complete!${NC}"
