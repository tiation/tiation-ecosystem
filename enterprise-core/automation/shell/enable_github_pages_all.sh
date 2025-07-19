#!/bin/bash

# Enable GitHub Pages for all Tiation repositories
# This script uses GitHub CLI to enable Pages on the main/master branch

echo "🔮 Enabling GitHub Pages for Tiation repositories..."

# List of repositories to enable GitHub Pages for
REPOS=(
    "tiation-cms"
    "tiation-ai-platform" 
    "tiation-docker-debian"
    "tiation-github-pages-theme"
    "tiation-terminal-workflows"
    "tiation-ai-agents"
)

# Function to enable GitHub Pages for a repository
enable_pages() {
    local repo=$1
    echo "📄 Enabling GitHub Pages for $repo..."
    
    cd "$repo" || { echo "❌ Failed to enter $repo directory"; return 1; }
    
    # Check if we're in the right directory
    if [[ ! -d ".git" ]]; then
        echo "❌ Not a git repository: $repo"
        cd ..
        return 1
    fi
    
    # Get the default branch name
    DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5 2>/dev/null || echo "main")
    
    # Enable GitHub Pages using GitHub CLI
    if command -v gh &> /dev/null; then
        echo "🌐 Using GitHub CLI to enable Pages for $repo..."
        gh api --method POST "/repos/tiation/$repo/pages" \
            --field source.branch="$DEFAULT_BRANCH" \
            --field source.path="/" \
            2>/dev/null && echo "✅ GitHub Pages enabled for $repo" || echo "⚠️  GitHub Pages may already be enabled for $repo"
    else
        echo "⚠️  GitHub CLI not found. Please enable GitHub Pages manually for $repo"
        echo "   Go to: https://github.com/tiation/$repo/settings/pages"
        echo "   Set source to: Deploy from a branch"
        echo "   Select branch: $DEFAULT_BRANCH"
        echo "   Select folder: / (root)"
    fi
    
    cd ..
}

# Enable GitHub Pages for each repository
for repo in "${REPOS[@]}"; do
    if [[ -d "$repo" ]]; then
        enable_pages "$repo"
    else
        echo "⚠️  Repository directory not found: $repo"
    fi
    echo ""
done

echo "🎉 GitHub Pages setup complete!"
echo ""
echo "📝 Your sites will be available at:"
for repo in "${REPOS[@]}"; do
    echo "   https://tiation.github.io/$repo/"
done
echo ""
echo "⏰ Note: It may take a few minutes for the sites to become live."
