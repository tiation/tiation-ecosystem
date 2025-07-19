#!/bin/bash

# Script to push all RiggerConnect split repos to GitHub
# Run this AFTER creating the GitHub repositories

set -e

# Define repository names
repos=(
    "tiation-rigger-automation-server"
    "tiation-rigger-connect-api"
    "tiation-rigger-connect-app"
    "tiation-rigger-jobs-app"
    "tiation-rigger-infrastructure"
    "tiation-rigger-mobile-app"
    "tiation-rigger-shared-libraries"
    "tiation-rigger-metrics-dashboard"
    "tiation-rigger-workspace-docs"
)

# Get GitHub username
GITHUB_USERNAME=$(gh api user --jq '.login')

echo "Pushing repositories to GitHub for user: $GITHUB_USERNAME"
echo "=================================================="

# Function to push a single repository
push_repo() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/$repo_name"
    
    echo "Processing: $repo_name"
    
    if [ ! -d "$repo_path" ]; then
        echo "❌ Directory not found: $repo_path"
        return 1
    fi
    
    cd "$repo_path"
    
    # Check if it's a git repository
    if [ ! -d ".git" ]; then
        echo "❌ Not a git repository: $repo_path"
        return 1
    fi
    
    # Add remote if it doesn't exist
    if ! git remote get-url origin &> /dev/null; then
        echo "Adding remote origin..."
        git remote add origin "https://github.com/$GITHUB_USERNAME/$repo_name.git"
    fi
    
    # Push to GitHub
    echo "Pushing to GitHub..."
    if git push -u origin main; then
        echo "✅ Successfully pushed: $repo_name"
    else
        echo "❌ Failed to push: $repo_name"
        return 1
    fi
    
    echo "---"
}

# Push each repository
for repo in "${repos[@]}"; do
    push_repo "$repo"
done

echo "=================================================="
echo "All repositories pushed! Next steps:"
echo "1. Check your GitHub repositories are populated"
echo "2. Configure GitHub Pages for tiation-rigger-workspace-docs"
echo "3. Set up CI/CD workflows and secrets"
echo ""
echo "GitHub Pages setup:"
echo "- Go to: https://github.com/$GITHUB_USERNAME/tiation-rigger-workspace-docs/settings/pages"
echo "- Set source to 'GitHub Actions'"
echo "- The site will be available at: https://$GITHUB_USERNAME.github.io/tiation-rigger-workspace-docs/"
