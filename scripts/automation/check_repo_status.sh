#!/bin/bash

echo "🔍 Repository Sync Status Summary"
echo "=================================="

repos=$(find /Users/tiaastor/tiation-github -name ".git" -type d | sed 's|/.git||')
successful=0
failed=0
total=0

for repo in $repos; do
    total=$((total + 1))
    repo_name=$(basename "$repo")
    
    cd "$repo" || continue
    
    # Check if there's a remote origin
    if ! git remote get-url origin > /dev/null 2>&1; then
        echo "⚠️  $repo_name - No remote origin"
        continue
    fi
    
    # Check if there are uncommitted changes
    if ! git diff --quiet || ! git diff --staged --quiet; then
        echo "📝 $repo_name - Has uncommitted changes"
        continue
    fi
    
    # Try to get the last commit info
    last_commit=$(git log -1 --oneline 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        successful=$((successful + 1))
        echo "✅ $repo_name - Synced: $last_commit"
    else
        failed=$((failed + 1))
        echo "❌ $repo_name - Failed"
    fi
done

echo ""
echo "Summary:"
echo "--------"
echo "Total repositories: $total"
echo "Successfully synced: $successful"
echo "Failed: $failed"
echo "Repos without remote: $((total - successful - failed))"
