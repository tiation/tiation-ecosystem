#!/bin/bash

# 🌟 Enable GitHub Pages for Tiation Repositories
# Enables GitHub Pages for all repositories using GitHub CLI

echo "🌟 Enabling GitHub Pages for Tiation Repositories"
echo "Contact: tiatheone@protonmail.com"
echo ""

# List of repositories to enable GitHub Pages for
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

# Function to enable GitHub Pages for a repository
enable_github_pages() {
    local repo_name=$1
    
    echo "Enabling GitHub Pages for $repo_name..."
    
    # Create JSON payload for enabling GitHub Pages
    local json_payload=$(cat <<EOF
{
  "source": {
    "branch": "main",
    "path": "/"
  },
  "build_type": "legacy"
}
EOF
)
    
    # Try to enable GitHub Pages using GitHub CLI
    if echo "$json_payload" | gh api repos/tiaastor/$repo_name/pages -X POST --input -; then
        echo "✓ GitHub Pages enabled for $repo_name"
        echo "🌐 Live at: https://tiaastor.github.io/$repo_name"
    else
        echo "⚠ Failed to enable GitHub Pages for $repo_name (may already be enabled)"
        # Try with master branch for older repositories
        local json_payload_master=$(cat <<EOF
{
  "source": {
    "branch": "master",
    "path": "/"
  },
  "build_type": "legacy"
}
EOF
)
        if echo "$json_payload_master" | gh api repos/tiaastor/$repo_name/pages -X POST --input -; then
            echo "✓ GitHub Pages enabled for $repo_name (using master branch)"
            echo "🌐 Live at: https://tiaastor.github.io/$repo_name"
        else
            echo "⚠ Could not enable GitHub Pages for $repo_name"
        fi
    fi
    
    echo ""
}

# Function to test if GitHub Pages is working
test_github_pages() {
    local repo_name=$1
    
    echo "Testing GitHub Pages for $repo_name..."
    
    # Test the URL
    local status_code=$(curl -s -o /dev/null -w "%{http_code}" "https://tiaastor.github.io/$repo_name")
    
    if [ "$status_code" = "200" ]; then
        echo "✓ GitHub Pages is working for $repo_name"
    elif [ "$status_code" = "404" ]; then
        echo "⚠ GitHub Pages not yet available for $repo_name (may take a few minutes)"
    else
        echo "⚠ GitHub Pages returned status $status_code for $repo_name"
    fi
    
    echo ""
}

# Check if GitHub CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not available. Please install it first."
    exit 1
fi

# Process each repository
echo "🚀 Enabling GitHub Pages for all repositories..."
echo ""

for repo in "${repositories[@]}"; do
    enable_github_pages "$repo"
done

echo "⏳ Waiting 30 seconds for GitHub Pages to process..."
sleep 30

echo "🧪 Testing GitHub Pages URLs..."
echo ""

for repo in "${repositories[@]}"; do
    test_github_pages "$repo"
done

echo "✅ GitHub Pages setup complete!"
echo ""
echo "📝 Manual Steps Required:"
echo "1. Go to each repository settings on GitHub"
echo "2. Navigate to 'Pages' section"
echo "3. Set source to 'Deploy from a branch'"
echo "4. Select branch (main/master) and root folder"
echo "5. Save settings"
echo ""
echo "🌐 Your repositories will be available at:"
for repo in "${repositories[@]}"; do
    echo "   https://tiaastor.github.io/$repo"
done
echo ""
echo "Built with ❤️ and enterprise-grade standards by Tiation"
