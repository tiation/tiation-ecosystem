#!/bin/bash

# Update GitHub Pages configuration for repositories to use promotional folder

echo "🔧 Updating GitHub Pages configuration for repositories..."

# Repositories that need their GitHub Pages configuration updated
repos=(
    "tiation-automation-workspace"
    "tiation-ai-platform"
    "tiation-macos-networking-guide"
    "tiation-ai-code-assistant"
    "tiation-private-ai-chat"
    "tiation-rigger-connect-api"
    "tiation-infrastructure-charms"
    "tiation-knowledge-base-ai"
)

success_count=0
failed_count=0

for repo in "${repos[@]}"; do
    echo "🔄 Updating GitHub Pages configuration for $repo..."
    
    # Try to update GitHub Pages configuration using the GitHub API
    response=$(gh api repos/tiation/$repo/pages -X PUT \
        --field source.branch=main \
        --field source.path=/promotional 2>&1)
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully updated GitHub Pages configuration for $repo"
        ((success_count++))
    else
        echo "⚠️  Failed to update GitHub Pages configuration for $repo"
        echo "   Response: $response"
        ((failed_count++))
    fi
    
    # Add a small delay to avoid rate limiting
    sleep 1
done

echo ""
echo "📊 Summary:"
echo "  • Successfully updated: $success_count"
echo "  • Failed: $failed_count"
echo "  • Total repositories: ${#repos[@]}"
echo ""

# Let's also check the current pages configuration for a few repos
echo "🔍 Checking current GitHub Pages configuration..."

check_repos=("tiation-terminal-workflows" "tiation-docker-debian" "tiation-ai-agents")

for repo in "${check_repos[@]}"; do
    echo "📋 Checking $repo..."
    gh api repos/tiation/$repo/pages --jq '.source' 2>/dev/null || echo "   Pages not configured"
    sleep 1
done

echo ""
echo "🌐 Your promotional sites should be available at:"
all_repos=(
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

for repo in "${all_repos[@]}"; do
    echo "  • https://tiation.github.io/$repo/"
done

echo ""
echo "⏰ GitHub Pages may take a few minutes to deploy."
echo "📝 For any repositories that still need manual configuration, visit:"
echo "   https://github.com/tiation/REPO_NAME/settings/pages"
