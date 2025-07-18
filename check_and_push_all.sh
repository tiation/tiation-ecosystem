#!/bin/bash

echo "🚀 Checking and pushing all repositories..."
echo "========================================"

# Get all git repositories (excluding nested .git folders in node_modules)
repos=$(find . -name ".git" -type d | grep -v "node_modules" | sed 's|/.git||' | sort)

total_repos=0
repos_with_changes=0
repos_pushed=0
repos_with_errors=0

for repo in $repos; do
    if [ -d "$repo/.git" ]; then
        total_repos=$((total_repos + 1))
        echo ""
        echo "📁 Checking: $repo"
        echo "----------------------------------------"
        
        cd "$repo"
        
        # Check if there are any uncommitted changes
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "⚠️  Uncommitted changes found. Committing them first..."
            git add .
            git commit -m "Auto-commit: Push all changes to remote"
            repos_with_changes=$((repos_with_changes + 1))
        fi
        
        # Check if there are commits to push
        if [ -n "$(git log --oneline @{upstream}..HEAD 2>/dev/null)" ]; then
            echo "🔄 Pushing changes to remote..."
            if git push; then
                echo "✅ Successfully pushed!"
                repos_pushed=$((repos_pushed + 1))
            else
                echo "❌ Failed to push"
                repos_with_errors=$((repos_with_errors + 1))
            fi
        else
            echo "✅ Already up to date"
        fi
        
        cd - > /dev/null
    fi
done

echo ""
echo "========================================"
echo "📊 Summary:"
echo "  Total repositories: $total_repos"
echo "  Repositories with uncommitted changes: $repos_with_changes"
echo "  Repositories pushed: $repos_pushed"
echo "  Repositories with errors: $repos_with_errors"
echo "========================================"
