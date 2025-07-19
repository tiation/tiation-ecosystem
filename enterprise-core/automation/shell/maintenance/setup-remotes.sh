#!/bin/bash

set -e

BASE_DIR="/Users/tiaastor/tiation-github"
GITHUB_ORG="tiation"

echo "🚀 Setting up remote repositories and pushing to GitHub..."

# List of repositories to process
REPOS=(
    "tiation-rigger-automation-server"
    "tiation-rigger-connect-app"
    "tiation-rigger-jobs-app"
    "tiation-rigger-infrastructure"
    "tiation-rigger-shared-libraries"
    "tiation-rigger-metrics-dashboard"
    "tiation-rigger-workspace-docs"
)

# Function to setup remote and push
setup_repo() {
    local repo_name="$1"
    local repo_dir="$BASE_DIR/$repo_name"
    
    echo "📁 Setting up remote for: $repo_name"
    
    cd "$repo_dir"
    
    # Check if we have any commits
    if ! git log --oneline -1 >/dev/null 2>&1; then
        echo "  📝 Making initial commit..."
        git add .
        git commit -m "feat: initial repository setup with enterprise features"
    fi
    
    # Check if remote already exists
    if ! git remote get-url origin >/dev/null 2>&1; then
        echo "  🔗 Adding remote origin..."
        git remote add origin "https://github.com/$GITHUB_ORG/$repo_name.git"
    else
        echo "  ✅ Remote origin already exists"
    fi
    
    # Create main branch if it doesn't exist
    if ! git show-ref --verify --quiet refs/heads/main; then
        echo "  🌿 Creating main branch..."
        git checkout -b main
    fi
    
    echo "  📤 Pushing to GitHub..."
    # Note: This will fail if the GitHub repo doesn't exist yet
    # You'll need to create the repositories on GitHub first
    git push -u origin main 2>/dev/null || echo "  ⚠️  Push failed - ensure GitHub repository exists"
    
    echo "  ✅ Repository $repo_name setup complete"
    echo ""
}

# Process each repository
for repo in "${REPOS[@]}"; do
    if [ -d "$BASE_DIR/$repo" ]; then
        setup_repo "$repo"
    else
        echo "⚠️  Repository directory $repo not found, skipping..."
    fi
done

echo "🎉 Remote setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Create repositories on GitHub if they don't exist yet"
echo "  2. Run: gh repo create tiation/repo-name --public"
echo "  3. Then re-run this script to push the code"
