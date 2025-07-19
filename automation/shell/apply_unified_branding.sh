#!/bin/bash

# Script to apply unified dark neon branding to all Tiation repositories
# This script updates README files with consistent branding elements

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Counter for repositories processed
total_repos=0
repos_updated=0
repos_skipped=0

echo -e "${CYAN}🔮 TIATION ECOSYSTEM BRANDING UPDATE${NC}"
echo -e "${MAGENTA}=================================================${NC}"
echo -e "${BLUE}Applying unified dark neon branding to all repositories...${NC}"

# Brand templates
ECOSYSTEM_BANNER='![Tiation Ecosystem](https://img.shields.io/badge/🔮_TIATION_ECOSYSTEM-REPO_NAME-00FFFF?style=for-the-badge&labelColor=0A0A0A&color=FF00FF)'
ECOSYSTEM_FOOTER='## 🔮 Tiation Ecosystem

This repository is part of the Tiation ecosystem. Explore related projects:

- [🌟 TiaAstor](https://github.com/TiaAstor/TiaAstor) - Personal brand and story
- [🐰 ChaseWhiteRabbit NGO](https://github.com/tiation/tiation-chase-white-rabbit-ngo) - Social impact initiatives
- [🏗️ Infrastructure](https://github.com/tiation/tiation-rigger-infrastructure) - Enterprise infrastructure
- [🤖 AI Agents](https://github.com/tiation/tiation-ai-agents) - Intelligent automation
- [📝 CMS](https://github.com/tiation/tiation-cms) - Content management system
- [⚡ Terminal Workflows](https://github.com/tiation/tiation-terminal-workflows) - Developer tools

---
*Built with 💜 by the Tiation team*'

# Function to update README with branding
update_readme() {
    local repo_path=$1
    local repo_name=$(basename "$repo_path")
    
    # Skip if no README exists
    if [[ ! -f "$repo_path/README.md" ]]; then
        echo -e "   ${YELLOW}⚠ No README.md found, skipping${NC}"
        return 1
    fi
    
    # Create backup
    cp "$repo_path/README.md" "$repo_path/README.md.backup"
    
    # Read current README
    local readme_content=$(cat "$repo_path/README.md")
    
    # Check if already has Tiation branding
    if echo "$readme_content" | grep -q "🔮_TIATION_ECOSYSTEM"; then
        echo -e "   ${BLUE}ℹ Already has Tiation branding${NC}"
        return 0
    fi
    
    # Generate branded README
    cat > "$repo_path/README.md" << EOF
# $(echo "$readme_content" | head -1 | sed 's/^# //')

<div align="center">

![Tiation Ecosystem](https://img.shields.io/badge/🔮_TIATION_ECOSYSTEM-${repo_name//-/_}-00FFFF?style=for-the-badge&labelColor=0A0A0A&color=FF00FF)

**Enterprise-grade solution in the Tiation ecosystem**

*Professional • Scalable • Mission-Driven*

[![Live Demo](https://img.shields.io/badge/🌐_Live_Demo-View_Project-00FFFF?style=flat-square&labelColor=0A0A0A)](https://github.com/tiation/${repo_name})
[![Documentation](https://img.shields.io/badge/📚_Documentation-Complete-007FFF?style=flat-square&labelColor=0A0A0A)](docs/)
[![Status](https://img.shields.io/badge/⚡_Status-Active_Development-FF00FF?style=flat-square&labelColor=0A0A0A)](https://github.com/tiation/${repo_name})
[![License](https://img.shields.io/badge/📄_License-MIT-00FFFF?style=flat-square&labelColor=0A0A0A)](LICENSE)

</div>

$(echo "$readme_content" | tail -n +2)

---

$ECOSYSTEM_FOOTER
EOF
    
    echo -e "   ${GREEN}✓ README updated with Tiation branding${NC}"
    return 0
}

# Find all git repositories and update them
while IFS= read -r -d '' repo_path; do
    repo_dir=$(dirname "$repo_path")
    repo_name=$(basename "$repo_dir")
    
    echo -e "\n${CYAN}📁 Processing: $repo_name${NC}"
    echo "   Path: $repo_dir"
    
    cd "$repo_dir"
    total_repos=$((total_repos + 1))
    
    if update_readme "$repo_dir"; then
        repos_updated=$((repos_updated + 1))
    else
        repos_skipped=$((repos_skipped + 1))
    fi
    
done < <(find /Users/tiaastor/tiation-github -name ".git" -type d -not -path "*/.*" -print0)

echo -e "\n${MAGENTA}=================================================${NC}"
echo -e "${CYAN}📊 Branding Update Summary:${NC}"
echo -e "   Total repositories processed: $total_repos"
echo -e "   Repositories updated: $repos_updated"
echo -e "   Repositories skipped: $repos_skipped"

if [ $repos_updated -gt 0 ]; then
    echo -e "\n${GREEN}🎉 Successfully applied unified branding to $repos_updated repositories!${NC}"
fi

echo -e "\n${CYAN}✨ Tiation Ecosystem branding update completed!${NC}"
