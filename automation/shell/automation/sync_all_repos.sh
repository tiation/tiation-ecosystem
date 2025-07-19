#!/bin/bash

# Script to sync all repositories with remote GitHub
# This script will check status, add changes, commit, and push to remote

echo "🔄 Starting repository sync process..."
echo "========================================"

# Find all git repositories
repos=$(find /Users/tiaastor/tiation-github -name ".git" -type d | sed 's|/.git||')

total_repos=$(echo "$repos" | wc -l)
current_repo=0

for repo in $repos; do
    current_repo=$((current_repo + 1))
    repo_name=$(basename "$repo")
    
    echo ""
    echo "[$current_repo/$total_repos] Processing: $repo_name"
    echo "----------------------------------------"
    
    cd "$repo" || continue
    
    # Check if this is a valid git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not a valid git repository: $repo"
        continue
    fi
    
    # Check if there's a remote origin
    if ! git remote get-url origin > /dev/null 2>&1; then
        echo "⚠️  No remote origin configured for: $repo_name"
        continue
    fi
    
    # Get current branch
    current_branch=$(git branch --show-current)
    echo "📍 Current branch: $current_branch"
    
    # Check git status
    if git diff --quiet && git diff --staged --quiet; then
        echo "✅ No changes to commit in $repo_name"
    else
        echo "📝 Changes detected in $repo_name"
        
        # Show brief status
        git status --porcelain | head -10
        
        # Add all changes
        git add -A
        
        # Commit with timestamp
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        git commit -m "Auto-sync: Repository updates - $timestamp"
        
        echo "✅ Changes committed"
    fi
    
    # Try to push to remote
    echo "🚀 Pushing to remote..."
    if git push origin "$current_branch" 2>/dev/null; then
        echo "✅ Successfully pushed $repo_name"
    else
        echo "❌ Failed to push $repo_name - may need authentication or remote doesn't exist"
        # Try to set upstream if it doesn't exist
        if git push --set-upstream origin "$current_branch" 2>/dev/null; then
            echo "✅ Set upstream and pushed $repo_name"
        else
            echo "❌ Could not set upstream for $repo_name"
        fi
    fi
    
    echo "Done with $repo_name"
done

echo ""
echo "========================================"
echo "🎉 Repository sync process completed!"
echo "Processed $total_repos repositories"
