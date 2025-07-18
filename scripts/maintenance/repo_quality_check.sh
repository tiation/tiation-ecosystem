#!/bin/bash

# Repository Quality Assessment Script
# Evaluates repositories based on enterprise-grade criteria

echo "=== REPOSITORY QUALITY ASSESSMENT ==="
echo "Checking for enterprise-grade indicators..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Arrays to track quality levels
declare -a high_quality=()
declare -a medium_quality=()
declare -a low_quality=()

# Function to check repository quality
check_repo_quality() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    echo "Checking: $repo_name"
    
    # Skip if not a directory
    if [[ ! -d "$repo_path" ]]; then
        return
    fi
    
    # Initialize score
    local score=0
    local issues=()
    
    # Check for README
    if [[ -f "$repo_path/README.md" ]] || [[ -f "$repo_path/readme.md" ]] || [[ -f "$repo_path/README.txt" ]]; then
        score=$((score + 2))
        
        # Check README quality (length as proxy for detail)
        local readme_lines=0
        if [[ -f "$repo_path/README.md" ]]; then
            readme_lines=$(wc -l < "$repo_path/README.md" 2>/dev/null || echo 0)
        elif [[ -f "$repo_path/readme.md" ]]; then
            readme_lines=$(wc -l < "$repo_path/readme.md" 2>/dev/null || echo 0)
        elif [[ -f "$repo_path/README.txt" ]]; then
            readme_lines=$(wc -l < "$repo_path/README.txt" 2>/dev/null || echo 0)
        fi
        
        if [[ $readme_lines -gt 50 ]]; then
            score=$((score + 2))
        elif [[ $readme_lines -gt 20 ]]; then
            score=$((score + 1))
        else
            issues+=("README too short ($readme_lines lines)")
        fi
    else
        issues+=("No README file")
    fi
    
    # Check for documentation directory
    if [[ -d "$repo_path/docs" ]] || [[ -d "$repo_path/documentation" ]]; then
        score=$((score + 2))
    else
        issues+=("No docs directory")
    fi
    
    # Check for recent activity (last 6 months)
    cd "$repo_path" 2>/dev/null
    if [[ -d ".git" ]]; then
        local last_commit=$(git log -1 --format=%ct 2>/dev/null || echo 0)
        local six_months_ago=$(date -d "6 months ago" +%s 2>/dev/null || echo 0)
        
        if [[ $last_commit -gt $six_months_ago ]]; then
            score=$((score + 2))
        else
            issues+=("No recent commits (>6 months)")
        fi
        
        # Check total commits
        local commit_count=$(git rev-list --count HEAD 2>/dev/null || echo 0)
        if [[ $commit_count -gt 10 ]]; then
            score=$((score + 1))
        else
            issues+=("Few commits ($commit_count)")
        fi
    else
        issues+=("Not a git repository")
    fi
    
    # Check for common quality files
    if [[ -f "$repo_path/LICENSE" ]] || [[ -f "$repo_path/license" ]]; then
        score=$((score + 1))
    else
        issues+=("No LICENSE file")
    fi
    
    if [[ -f "$repo_path/.gitignore" ]]; then
        score=$((score + 1))
    else
        issues+=("No .gitignore")
    fi
    
    # Check for package/dependency files
    if [[ -f "$repo_path/package.json" ]] || [[ -f "$repo_path/requirements.txt" ]] || [[ -f "$repo_path/go.mod" ]] || [[ -f "$repo_path/pom.xml" ]] || [[ -f "$repo_path/Cargo.toml" ]]; then
        score=$((score + 1))
    fi
    
    # Check for CI/CD
    if [[ -d "$repo_path/.github" ]] || [[ -f "$repo_path/.gitlab-ci.yml" ]] || [[ -f "$repo_path/.travis.yml" ]]; then
        score=$((score + 1))
    fi
    
    # Calculate quality category
    if [[ $score -ge 8 ]]; then
        high_quality+=("$repo_name")
        echo -e "  ${GREEN}HIGH QUALITY${NC} (Score: $score/10)"
    elif [[ $score -ge 5 ]]; then
        medium_quality+=("$repo_name")
        echo -e "  ${YELLOW}MEDIUM QUALITY${NC} (Score: $score/10)"
    else
        low_quality+=("$repo_name")
        echo -e "  ${RED}LOW QUALITY${NC} (Score: $score/10)"
    fi
    
    # Show issues if any
    if [[ ${#issues[@]} -gt 0 ]]; then
        echo "    Issues: ${issues[*]}"
    fi
    
    echo ""
    cd - > /dev/null 2>&1
}

# Check all repositories
for repo in /Users/tiaastor/tiation-github/*/; do
    if [[ -d "$repo" ]]; then
        check_repo_quality "$repo"
    fi
done

# Summary
echo "=== SUMMARY ==="
echo -e "${GREEN}HIGH QUALITY REPOSITORIES (${#high_quality[@]}):${NC}"
printf '%s\n' "${high_quality[@]}" | sort
echo ""

echo -e "${YELLOW}MEDIUM QUALITY REPOSITORIES (${#medium_quality[@]}):${NC}"
printf '%s\n' "${medium_quality[@]}" | sort
echo ""

echo -e "${RED}LOW QUALITY REPOSITORIES (${#low_quality[@]}):${NC}"
printf '%s\n' "${low_quality[@]}" | sort
echo ""

echo "=== RECOMMENDATIONS ==="
echo "Consider deleting LOW QUALITY repositories that:"
echo "- Have no README or documentation"
echo "- Haven't been updated in 6+ months"
echo "- Have very few commits"
echo "- Serve no clear enterprise purpose"
