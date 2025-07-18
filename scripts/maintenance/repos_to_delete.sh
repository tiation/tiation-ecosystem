#!/bin/bash

# Repository Deletion Candidates Script
# Identifies repositories that should be deleted based on enterprise standards

echo "=== REPOSITORY DELETION CANDIDATES ==="
echo "Based on enterprise-grade requirements..."
echo ""

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Arrays for deletion candidates
declare -a delete_candidates=()
declare -a review_candidates=()

# Function to check if repo should be deleted
check_for_deletion() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    # Skip if not a directory
    if [[ ! -d "$repo_path" ]]; then
        return
    fi
    
    local delete_reasons=()
    local review_reasons=()
    local should_delete=false
    local should_review=false
    
    # Check if it's a git repository
    cd "$repo_path" 2>/dev/null
    if [[ ! -d ".git" ]]; then
        delete_reasons+=("Not a git repository")
        should_delete=true
    else
        # Check for README
        if [[ ! -f "$repo_path/README.md" ]] && [[ ! -f "$repo_path/readme.md" ]] && [[ ! -f "$repo_path/README.txt" ]]; then
            delete_reasons+=("No README file")
            should_delete=true
        fi
        
        # Check commit count
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo 0)
        if [[ $commit_count -le 3 ]]; then
            delete_reasons+=("Very few commits ($commit_count)")
            should_delete=true
        fi
        
        # Check for recent activity (last 12 months)
        local last_commit=$(git log -1 --format=%ct 2>/dev/null || echo 0)
        local twelve_months_ago=$(date -d "12 months ago" +%s 2>/dev/null || echo 0)
        
        if [[ $last_commit -lt $twelve_months_ago ]]; then
            review_reasons+=("No commits in 12+ months")
            should_review=true
        fi
    fi
    
    # Check for specific problematic patterns
    case "$repo_name" in
        "temp-"*|"test-"*|"demo-"*|"experimental-"*|"playground-"*)
            delete_reasons+=("Temporary/test repository")
            should_delete=true
            ;;
        "dontbeacunt")
            delete_reasons+=("Inappropriate name for enterprise")
            should_delete=true
            ;;
    esac
    
    # Output results
    if [[ "$should_delete" == true ]]; then
        delete_candidates+=("$repo_name")
        echo -e "${RED}DELETE: $repo_name${NC}"
        printf '  Reasons: %s\n' "${delete_reasons[@]}"
        echo ""
    elif [[ "$should_review" == true ]]; then
        review_candidates+=("$repo_name")
        echo -e "${YELLOW}REVIEW: $repo_name${NC}"
        printf '  Reasons: %s\n' "${review_reasons[@]}"
        echo ""
    fi
    
    cd - > /dev/null 2>&1
}

# Check all repositories
for repo in /Users/tiaastor/tiation-github/*/; do
    if [[ -d "$repo" ]]; then
        check_for_deletion "$repo"
    fi
done

# Summary
echo "=== DELETION SUMMARY ==="
echo -e "${RED}REPOSITORIES TO DELETE (${#delete_candidates[@]}):${NC}"
for repo in "${delete_candidates[@]}"; do
    echo "  - $repo"
done
echo ""

echo -e "${YELLOW}REPOSITORIES TO REVIEW (${#review_candidates[@]}):${NC}"
for repo in "${review_candidates[@]}"; do
    echo "  - $repo"
done
echo ""

# Generate deletion commands
if [[ ${#delete_candidates[@]} -gt 0 ]]; then
    echo "=== DELETION COMMANDS ==="
    echo "# Run these commands to delete the identified repositories:"
    echo ""
    for repo in "${delete_candidates[@]}"; do
        echo "rm -rf \"/Users/tiaastor/tiation-github/$repo\""
    done
    echo ""
    echo "# WARNING: This will permanently delete these repositories!"
    echo "# Make sure you have backups or are certain you want to delete them."
fi
