#!/bin/bash

# Enable GitHub Pages for all repositories using GitHub API

echo "🌐 Enabling GitHub Pages for all repositories..."

repos=(
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

success_count=0
failed_count=0

for repo in "${repos[@]}"; do
    echo "🔄 Enabling GitHub Pages for $repo..."
    
    # Try to enable GitHub Pages using the GitHub API
    response=$(gh api repos/tiation/$repo/pages -X POST \
        --field source.branch=main \
        --field source.path=/promotional 2>&1)
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully enabled GitHub Pages for $repo"
        ((success_count++))
    else
        echo "⚠️  Failed to enable GitHub Pages for $repo"
        echo "   Response: $response"
        ((failed_count++))
    fi
    
    # Add a small delay to avoid rate limiting
    sleep 1
done

echo ""
echo "📊 Summary:"
echo "  • Successfully enabled: $success_count"
echo "  • Failed: $failed_count"
echo "  • Total repositories: ${#repos[@]}"
echo ""
echo "🌐 Your promotional sites will be available at:"
for repo in "${repos[@]}"; do
    echo "  • https://tiation.github.io/$repo/"
done
echo ""
echo "⏰ GitHub Pages may take a few minutes to deploy."
echo "📝 If any repositories failed, you can manually enable GitHub Pages in the repository settings."
