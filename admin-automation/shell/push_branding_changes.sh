#!/bin/bash

# 🌟 Push Tiation Enterprise Branding Changes
# Commits and pushes all branding changes to remote repositories

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}🌟 Pushing Tiation Enterprise Branding Changes${NC}"
echo -e "${CYAN}Contact: tiatheone@protonmail.com${NC}"
echo ""

# List of repositories to push
repositories=(
    "tiation-terminal-workflows"
    "tiation-docker-debian"
    "tiation-ai-platform"
    "tiation-ai-agents"
    "tiation-cms"
    "tiation-go-sdk"
    "tiation-automation-workspace"
    "DiceRollerSimulator"
    "liberation-system"
    "tiation-chase-white-rabbit-ngo"
    "tiation-economic-reform-proposal"
    "tiation-macos-networking-guide"
    "tiation-parrot-security-guide-au"
    "ubuntu-dev-setup"
)

# Function to push repository changes
push_repository() {
    local repo_path=$1
    local repo_name=$2
    
    echo -e "${CYAN}Processing $repo_name...${NC}"
    
    # Change to repository directory
    cd "$repo_path" || {
        echo -e "${RED}✗ Could not change to $repo_path${NC}"
        return 1
    }
    
    # Check if there are any changes
    if git diff --quiet && git diff --staged --quiet; then
        echo -e "${YELLOW}⚠ No changes to commit in $repo_name${NC}"
        return 0
    fi
    
    # Add all changes
    git add .
    
    # Check if there are staged changes
    if git diff --staged --quiet; then
        echo -e "${YELLOW}⚠ No staged changes in $repo_name${NC}"
        return 0
    fi
    
    # Commit changes
    git commit -m "feat: add enterprise-grade branding with dark neon theme

- Add consistent README structure with enterprise standards
- Include dark neon theme with cyan/magenta gradient accents
- Add professional contact information: tiatheone@protonmail.com
- Create assets directory with branding guidelines
- Add GitHub issue and PR templates
- Include enterprise-grade footer and related projects section
- Ensure all links point to GitHub repositories"
    
    # Push to remote
    if git push origin HEAD; then
        echo -e "${GREEN}✓ Successfully pushed $repo_name${NC}"
    else
        echo -e "${RED}✗ Failed to push $repo_name${NC}"
        return 1
    fi
    
    echo ""
}

# Change to base directory
cd "/Users/tiaastor/tiation-github" || {
    echo -e "${RED}✗ Could not change to base directory${NC}"
    exit 1
}

# Process each repository
success_count=0
total_count=0

for repo in "${repositories[@]}"; do
    repo_path="/Users/tiaastor/tiation-github/$repo"
    
    if [ -d "$repo_path" ]; then
        total_count=$((total_count + 1))
        if push_repository "$repo_path" "$repo"; then
            success_count=$((success_count + 1))
        fi
    else
        echo -e "${YELLOW}Repository not found: $repo${NC}"
    fi
done

echo ""
echo -e "${CYAN}📊 Summary:${NC}"
echo -e "${GREEN}✓ Successfully pushed: $success_count repositories${NC}"
echo -e "${YELLOW}⚠ Total processed: $total_count repositories${NC}"

if [ $success_count -eq $total_count ]; then
    echo -e "${GREEN}🎉 All branding changes have been pushed successfully!${NC}"
    echo -e "${GREEN}Enterprise-grade branding is now live across all repositories${NC}"
else
    echo -e "${YELLOW}⚠ Some repositories may need manual attention${NC}"
fi

echo ""
echo -e "${CYAN}🚀 Next Steps:${NC}"
echo -e "${CYAN}1. Verify changes on GitHub${NC}"
echo -e "${CYAN}2. Set up GitHub Pages for live demos${NC}"
echo -e "${CYAN}3. Add screenshots to assets directories${NC}"
echo -e "${CYAN}4. Review and customize individual descriptions${NC}"
echo ""
echo -e "${GREEN}Built with ❤️ and enterprise-grade standards by Tiation${NC}"
