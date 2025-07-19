#!/bin/bash

# Script to fix repository index references
# We'll copy the index files to each repository so the relative links work

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

# First, let's create a central repository index that points to actual GitHub URLs
echo -e "${YELLOW}Creating updated repository index with GitHub URLs...${NC}"

# We need to update the REPOSITORY_INDEX.md to use GitHub URLs instead of relative paths
# For now, let's copy the index to each repository

echo -e "${YELLOW}Copying repository index files to each repository...${NC}"

for repo in "${REPOS[@]}"; do
    if [ -d "/Users/tiaastor/tiation-github/$repo" ]; then
        echo -e "Copying to $repo..."
        
        # Copy the index files
        cp /Users/tiaastor/tiation-github/REPOSITORY_INDEX.md "/Users/tiaastor/tiation-github/$repo/"
        cp /Users/tiaastor/tiation-github/REPOSITORY_GRAPH.md "/Users/tiaastor/tiation-github/$repo/"
        
        # Update the README.md to point to local index
        sed -i '' 's|\.\./REPOSITORY_INDEX\.md|./REPOSITORY_INDEX.md|g' "/Users/tiaastor/tiation-github/$repo/README.md"
        
        echo -e "${GREEN}✓ Updated $repo${NC}"
    else
        echo -e "${RED}⚠ Repository $repo not found, skipping...${NC}"
    fi
done

echo -e "\n${GREEN}Index reference fix complete!${NC}"
echo -e "\nNext steps:"
echo -e "1. Run the push script again to commit these changes"
echo -e "2. Or manually commit and push in each repository"
