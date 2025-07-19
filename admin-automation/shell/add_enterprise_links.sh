#!/bin/bash

# Script to add Enterprise Transformation Proposal link to remaining key repositories

ENTERPRISE_BADGE='[![🔮_Enterprise_Proposal](https://img.shields.io/badge/🔮_Enterprise_Transformation-$1.15M+_Revenue_Proposal-FC00FF?style=for-the-badge&logo=chartdotjs&logoColor=white)](https://tiation.github.io/enterprise-transformation-proposal)'

# List of remaining key repositories to update
REPOS=(
    "tiation-ai-agents"
    "tiation-terminal-workflows"
    "tiation-go-sdk"
    "tiation-docker-debian"
    "tiation-chase-white-rabbit-ngo"
)

# Base directory
BASE_DIR="/Users/tiaastor/tiation-github"

for repo in "${REPOS[@]}"; do
    REPO_PATH="$BASE_DIR/$repo"
    README_PATH="$REPO_PATH/README.md"
    
    if [ -d "$REPO_PATH" ] && [ -f "$README_PATH" ]; then
        echo "Processing $repo..."
        
        # Find the last badge line and add our enterprise proposal badge after it
        # Look for common badge patterns to find where to insert
        if grep -q "for-the-badge" "$README_PATH"; then
            # Find the last badge line
            LAST_BADGE_LINE=$(grep -n "for-the-badge" "$README_PATH" | tail -1 | cut -d: -f1)
            
            # Insert the enterprise proposal badge after the last badge
            sed -i '' "${LAST_BADGE_LINE}a\\
$ENTERPRISE_BADGE\\
" "$README_PATH"
            
            # Commit and push changes
            cd "$REPO_PATH"
            git add README.md
            git commit -m "Add Enterprise Transformation Proposal link - \$1.15M+ Revenue"
            git push origin main
            
            echo "✅ Updated $repo"
        else
            echo "❌ No badges found in $repo, skipping"
        fi
    else
        echo "❌ Repository $repo not found or no README.md"
    fi
done

echo "🎉 Enterprise Transformation Proposal links added to all key repositories!"
