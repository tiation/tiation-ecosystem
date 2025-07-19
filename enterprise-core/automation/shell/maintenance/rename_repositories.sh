#!/bin/bash

# Repository renaming script for Tiation organization
# This script renames repositories to be more descriptive and updates email addresses

set -e

EMAIL="tiatheone@protonmail.com"

echo "🚀 Starting Tiation Repository Renaming Process..."
echo "📧 Using email: $EMAIL"
echo ""

# Define repository mappings (current_name:new_name:description)
declare -A repo_mappings=(
    # Development Tools & Utilities
    ["developer"]="tiation-ai-developer-agent:AI developer agent embedding library"
    ["Roo-Cline"]="tiation-ai-code-assistant:Autonomous coding assistant for IDEs"
    ["smol-dev-js"]="tiation-js-development-ai:AI assistant for JavaScript development"
    ["git-workspace"]="tiation-git-workspace-manager:Git workspace management system"
    ["go-project-template"]="tiation-golang-project-template:Golang CLI project template"
    ["quick"]="tiation-github-pages-theme:GitHub Pages theme generator"
    ["workflows"]="tiation-terminal-workflows:Terminal workflow automation"
    
    # AI & Machine Learning
    ["FastGPT"]="tiation-knowledge-base-ai:Knowledge-based AI platform with RAG"
    ["privateGPT"]="tiation-private-ai-chat:Private AI chat system"
    ["open-webui"]="tiation-ai-platform:Self-hosted AI interface platform"
    ["payload"]="tiation-headless-cms:Next.js headless CMS platform"
    ["fpl-ai"]="tiation-sports-prediction-ai:Sports prediction AI system"
    
    # System Administration
    ["ubuntu-dev-setup"]="tiation-ubuntu-development-setup:Ubuntu development environment setup"
    ["windows-dev-setup"]="tiation-windows-development-setup:Windows development environment setup"
    ["dotfiles"]="tiation-system-dotfiles:Cross-platform system configuration files"
    ["mac-zsh-completions"]="tiation-macos-zsh-completions:macOS Zsh completion definitions"
    ["dockerdeb"]="tiation-docker-debian-manager:Docker management for Debian systems"
    ["claude-desktop-debian"]="tiation-claude-desktop-linux:Claude Desktop for Linux systems"
    ["headscale-admin"]="tiation-headscale-admin-ui:Headscale VPN admin interface"
    
    # Business & Enterprise
    ["19-trillion-solution"]="tiation-economic-reform-proposal:Australian economic reform proposal"
    ["ChaseWhiteRabbit"]="tiation-grief-to-design-ngo:NGO transforming grief into systemic change"
    ["company-intranet"]="tiation-company-intranet-template:Company intranet template"
    ["grieftodesign"]="tiation-grief-transformation-platform:Grief transformation platform"
    
    # Mobile & Gaming
    ["DiceRollerSimulator"]="tiation-dnd-dice-roller-ios:D&D dice roller iOS app"
    ["dnd_dice_roller"]="tiation-dnd-dice-roller-flutter:D&D dice roller Flutter app"
    ["flutter-intl-vscode"]="tiation-flutter-localization-vscode:Flutter localization VS Code extension"
    
    # Security & Networking
    ["015_VPN_Mesh"]="tiation-vpn-mesh-network:VPN mesh network implementation"
    ["Parrot-Security-Guide"]="tiation-parrot-security-guide:Parrot Security OS guide"
    ["ad-setup"]="tiation-active-directory-setup:Active Directory forest setup scripts"
    
    # Documentation & Guides
    ["afl-fantasy-manager-docs"]="tiation-afl-fantasy-docs:AFL Fantasy Manager documentation"
    ["Case_Study_Legal"]="tiation-legal-case-studies:Legal case study analysis"
    ["ProtectChildrenAustralia"]="tiation-child-protection-australia:Child protection resources"
    ["home"]="tiation-personal-homepage:Personal homepage and portfolio"
    
    # Utilities & Misc
    ["Intermap"]="tiation-interactive-map:Internet interactive mapping tool"
    ["huggingface-llama-recipes"]="tiation-llama-integration-recipes:LLaMA model integration recipes"
    ["AlmaStreet"]="tiation-alma-street-project:Alma Street project"
    ["charms"]="tiation-infrastructure-charms:Infrastructure deployment charms"
    ["lappy"]="tiation-laptop-utilities:Laptop utility tools"
    ["m4"]="tiation-m4-project:M4 project utilities"
    ["dontbeacunt"]="tiation-positive-communication:Positive communication guidelines"
    ["TiaAstor"]="tiation-founder-profile:Founder and CEO profile"
    ["tiation"]="tiation-organization-main:Main organization repository"
)

# Function to rename a repository
rename_repository() {
    local old_name="$1"
    local new_name="$2"
    local description="$3"
    
    echo "📝 Renaming: $old_name → $new_name"
    
    # Check if repository exists
    if ! gh repo view "tiation/$old_name" &>/dev/null; then
        echo "   ⚠️  Repository tiation/$old_name does not exist, skipping..."
        return
    fi
    
    # Rename the repository
    if gh repo rename "$new_name" --repo "tiation/$old_name" --yes; then
        echo "   ✅ Successfully renamed repository"
        
        # Update description separately
        if gh repo edit "tiation/$new_name" --description "$description"; then
            echo "   ✅ Successfully updated description"
        fi
        
        # Update local directory name if it exists
        if [ -d "$old_name" ]; then
            echo "   📁 Renaming local directory: $old_name → $new_name"
            mv "$old_name" "$new_name"
            
            # Update git remote in the renamed directory
            cd "$new_name"
            git remote set-url origin "https://github.com/tiation/$new_name.git"
            cd ..
        fi
    else
        echo "   ❌ Failed to rename repository"
    fi
    
    echo ""
}

# Function to update email addresses in a repository
update_email_in_repo() {
    local repo_dir="$1"
    local email="$2"
    
    if [ ! -d "$repo_dir" ]; then
        echo "   ⚠️  Directory $repo_dir does not exist, skipping email update..."
        return
    fi
    
    echo "   📧 Updating email addresses in $repo_dir"
    
    cd "$repo_dir"
    
    # Update common files that might contain email addresses
    find . -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.toml" \) -exec grep -l "@" {} \; | while read -r file; do
        if grep -q "@" "$file"; then
            # Replace common email patterns with the new email
            sed -i.bak "s/[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]*\.[a-zA-Z]{2,}/$email/g" "$file"
            if [ -f "$file.bak" ]; then
                rm "$file.bak"
            fi
            echo "     ✅ Updated email in $file"
        fi
    done
    
    cd ..
}

# Function to fix broken links in a repository
fix_broken_links() {
    local repo_dir="$1"
    
    if [ ! -d "$repo_dir" ]; then
        echo "   ⚠️  Directory $repo_dir does not exist, skipping link fixes..."
        return
    fi
    
    echo "   🔗 Fixing broken links in $repo_dir"
    
    cd "$repo_dir"
    
    # Find markdown files and fix common broken link patterns
    find . -type f -name "*.md" | while read -r file; do
        if [ -f "$file" ]; then
            # Fix relative links to point to GitHub
            sed -i.bak 's|\[([^]]*)\](\.\.\/[^)]*)|[\1](https://github.com/tiation/'"$repo_dir"'/blob/main/\2)|g' "$file"
            
            # Fix absolute links to point to GitHub when they're local
            sed -i.bak 's|\[([^]]*)\](\/[^)]*)|[\1](https://github.com/tiation/'"$repo_dir"'/blob/main\2)|g' "$file"
            
            if [ -f "$file.bak" ]; then
                rm "$file.bak"
            fi
        fi
    done
    
    cd ..
}

# Main execution
echo "🔄 Starting repository renaming process..."
echo ""

# Process each repository
for old_name in "${!repo_mappings[@]}"; do
    mapping="${repo_mappings[$old_name]}"
    new_name="${mapping%:*}"
    description="${mapping#*:}"
    
    rename_repository "$old_name" "$new_name" "$description"
    
    # Update email addresses and fix links in the renamed repository
    update_email_in_repo "$new_name" "$EMAIL"
    fix_broken_links "$new_name"
done

echo "🎉 Repository renaming process completed!"
echo ""
echo "📋 Summary:"
echo "   • Renamed ${#repo_mappings[@]} repositories"
echo "   • Updated email addresses to $EMAIL"
echo "   • Fixed broken links to point to GitHub"
echo ""
echo "⚠️  Please review the changes and commit/push any local modifications."
