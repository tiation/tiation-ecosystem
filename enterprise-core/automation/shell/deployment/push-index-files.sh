#!/bin/bash

# Script to commit and push repository index files

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

echo "Committing and pushing repository index files..."
echo "============================================================"

successful=0
failed=0

for repo in "${REPOS[@]}"; do
    echo -e "\n${YELLOW}Processing $repo...${NC}"
    
    cd "/Users/tiaastor/tiation-github/$repo" || {
        echo -e "${RED}✗ Failed to change to $repo directory${NC}"
        ((failed++))
        continue
    }
    
    # Add the index files and updated README
    git add REPOSITORY_INDEX.md REPOSITORY_GRAPH.md README.md
    
    # Commit changes
    git commit -m "Add repository index files and fix references

- Added REPOSITORY_INDEX.md for complete repository overview
- Added REPOSITORY_GRAPH.md for visual dependency mapping
- Fixed README references to point to local index files
- Ensures all cross-references work properly on GitHub" || {
        echo -e "${YELLOW}No changes to commit in $repo${NC}"
        continue
    }
    
    # Push changes
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || {
        echo -e "${RED}✗ Failed to push $repo${NC}"
        ((failed++))
        continue
    }
    
    echo -e "${GREEN}✓ Successfully pushed index files to $repo${NC}"
    ((successful++))
done

echo -e "\n============================================================"
echo -e "${GREEN}Summary:${NC}"
echo -e "  Successful pushes: ${GREEN}$successful${NC}"
echo -e "  Failed: ${RED}$failed${NC}"
echo -e "\n${GREEN}Repository index deployment complete!${NC}"
