#!/bin/bash

# Push Wiki Documentation Changes to GitHub
echo "🚀 Pushing wiki documentation changes to GitHub repositories..."

# Counter for tracking progress
total_repos=0
success_count=0
failed_count=0

# Function to push changes for a single repository
push_repo_changes() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    # Skip non-git directories
    if [[ ! -d "$repo_path/.git" ]]; then
        echo "⚠️  Skipping $repo_name (not a git repository)"
        return
    fi
    
    echo "📁 Processing: $repo_name"
    cd "$repo_path"
    
    # Check if there are changes to commit
    if git diff --quiet && git diff --staged --quiet; then
        echo "✅ No changes to commit in $repo_name"
        cd ..
        return
    fi
    
    # Add all changes
    git add .
    
    # Commit changes
    if git commit -m "✨ Add comprehensive wiki documentation with FAQ and troubleshooting

- Added detailed FAQ section with general, technical, and advanced questions
- Added comprehensive troubleshooting guide with common issues and solutions
- Enhanced documentation structure with dark neon theme information
- Added quick links and additional resources
- Improved enterprise-grade documentation standards"; then
        echo "✅ Committed changes for $repo_name"
    else
        echo "❌ Failed to commit changes for $repo_name"
        ((failed_count++))
        cd ..
        return
    fi
    
    # Push to origin main (or master)
    if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
        echo "🚀 Successfully pushed $repo_name to GitHub"
        ((success_count++))
    else
        echo "❌ Failed to push $repo_name to GitHub"
        ((failed_count++))
    fi
    
    cd ..
    ((total_repos++))
}

# Process all repositories
for repo in $(find . -maxdepth 1 -type d ! -name "." ! -name "node_modules"); do
    push_repo_changes "$repo"
done

# Summary
echo ""
echo "📊 Push Summary:"
echo "   Total repositories processed: $total_repos"
echo "   Successfully pushed: $success_count"
echo "   Failed to push: $failed_count"

if [[ $success_count -gt 0 ]]; then
    echo "🎉 Wiki documentation successfully pushed to GitHub!"
fi

if [[ $failed_count -gt 0 ]]; then
    echo "⚠️  Some repositories failed to push. Check the output above for details."
fi
