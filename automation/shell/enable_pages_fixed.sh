#!/bin/bash

# 🌟 Enable GitHub Pages via CLI for Tiation Repositories
# Uses GitHub CLI to enable GitHub Pages for all repositories

echo "🌟 Enabling GitHub Pages via CLI for Tiation Repositories"
echo "Contact: tiatheone@protonmail.com"
echo ""

# Function to get branch for repository
get_branch() {
    local repo=$1
    case $repo in
        "tiation-docker-debian"|"DiceRollerSimulator"|"tiation-chase-white-rabbit-ngo")
            echo "master"
            ;;
        "tiation-economic-reform-proposal")
            echo "gh-pages"
            ;;
        *)
            echo "main"
            ;;
    esac
}

# List of repositories
repositories=(
    "tiation-terminal-workflows"
    "tiation-docker-debian"
    "tiation-ai-platform"
    "tiation-ai-agents"
    "tiation-cms"
    "tiation-go-sdk"
    "tiation-automation-workspace"
    "DiceRollerSimulator"
    "liberation-system"
    "tiation-chase-white-rabbit-ngo"
    "tiation-economic-reform-proposal"
    "tiation-macos-networking-guide"
    "tiation-parrot-security-guide-au"
    "ubuntu-dev-setup"
)

# Check if GitHub CLI is available and authenticated
check_gh_cli() {
    echo "🔍 Checking GitHub CLI..."
    
    if ! command -v gh &> /dev/null; then
        echo "❌ GitHub CLI (gh) is not installed."
        echo "Please install it: brew install gh"
        exit 1
    fi
    
    # Check authentication
    if ! gh auth status &> /dev/null; then
        echo "❌ GitHub CLI is not authenticated."
        echo "Please authenticate: gh auth login"
        exit 1
    fi
    
    echo "✅ GitHub CLI is ready"
    echo ""
}

# Function to enable GitHub Pages for a repository
enable_github_pages() {
    local repo_name=$1
    local branch=$(get_branch "$repo_name")
    
    echo "🚀 Enabling GitHub Pages for $repo_name (branch: $branch)..."
    
    # Create temporary JSON file for the request
    local temp_file=$(mktemp)
    cat > "$temp_file" << EOF
{
  "source": {
    "branch": "$branch",
    "path": "/"
  }
}
EOF
    
    # Try to enable GitHub Pages
    if gh api repos/tiaastor/$repo_name/pages --method POST --input "$temp_file" > /dev/null 2>&1; then
        echo "✅ GitHub Pages enabled for $repo_name"
        echo "🌐 URL: https://tiaastor.github.io/$repo_name"
        
        # Check build status
        sleep 2
        local build_status=$(gh api repos/tiaastor/$repo_name/pages --jq '.status' 2>/dev/null || echo "unknown")
        echo "📊 Build status: $build_status"
        
    else
        echo "⚠️  Failed to enable GitHub Pages for $repo_name"
        echo "🔍 Checking if already enabled..."
        
        # Check if GitHub Pages is already enabled
        if gh api repos/tiaastor/$repo_name/pages > /dev/null 2>&1; then
            local current_source=$(gh api repos/tiaastor/$repo_name/pages --jq '.source.branch' 2>/dev/null || echo "unknown")
            local page_url=$(gh api repos/tiaastor/$repo_name/pages --jq '.html_url' 2>/dev/null || echo "unknown")
            echo "✅ GitHub Pages already enabled for $repo_name"
            echo "🌐 URL: $page_url"
            echo "📂 Source branch: $current_source"
        else
            echo "❌ Could not enable or check GitHub Pages for $repo_name"
            echo "🔧 You may need to enable it manually in the repository settings"
        fi
    fi
    
    # Clean up temporary file
    rm -f "$temp_file"
    echo ""
}

# Function to check GitHub Pages status
check_github_pages_status() {
    local repo_name=$1
    
    echo "🔍 Checking status for $repo_name..."
    
    if gh api repos/tiaastor/$repo_name/pages > /dev/null 2>&1; then
        local status=$(gh api repos/tiaastor/$repo_name/pages --jq '.status' 2>/dev/null || echo "unknown")
        local url=$(gh api repos/tiaastor/$repo_name/pages --jq '.html_url' 2>/dev/null || echo "unknown")
        local source_branch=$(gh api repos/tiaastor/$repo_name/pages --jq '.source.branch' 2>/dev/null || echo "unknown")
        
        echo "✅ GitHub Pages enabled for $repo_name"
        echo "   Status: $status"
        echo "   URL: $url"
        echo "   Source: $source_branch"
        
        # Test the URL
        local http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        if [ "$http_status" = "200" ]; then
            echo "   🌐 Site is live and accessible"
        elif [ "$http_status" = "404" ]; then
            echo "   ⏳ Site is building (404 - may take a few minutes)"
        else
            echo "   ⚠️  Site returned HTTP $http_status"
        fi
    else
        echo "❌ GitHub Pages not enabled for $repo_name"
    fi
    echo ""
}

# Function to test all GitHub Pages URLs
test_all_pages() {
    echo "🧪 Testing all GitHub Pages URLs..."
    echo ""
    
    for repo_name in "${repositories[@]}"; do
        local url="https://tiaastor.github.io/$repo_name"
        local status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        
        if [ "$status_code" = "200" ]; then
            echo "✅ $repo_name - Site is live: $url"
        elif [ "$status_code" = "404" ]; then
            echo "⏳ $repo_name - Building: $url"
        else
            echo "❌ $repo_name - HTTP $status_code: $url"
        fi
    done
    echo ""
}

# Main execution
main() {
    check_gh_cli
    
    echo "🚀 Starting GitHub Pages enablement process..."
    echo ""
    
    # Enable GitHub Pages for each repository
    for repo_name in "${repositories[@]}"; do
        enable_github_pages "$repo_name"
    done
    
    echo "⏳ Waiting 30 seconds for GitHub to process..."
    sleep 30
    
    echo "📊 Checking GitHub Pages status for all repositories..."
    echo ""
    
    # Check status for each repository
    for repo_name in "${repositories[@]}"; do
        check_github_pages_status "$repo_name"
    done
    
    echo "🧪 Final URL test..."
    echo ""
    test_all_pages
    
    echo "✅ GitHub Pages setup complete!"
    echo ""
    echo "📝 Summary:"
    echo "- All repositories have been processed"
    echo "- GitHub Pages should be enabled where possible"
    echo "- Sites may take 5-10 minutes to become fully available"
    echo "- Check individual repository settings if any failed"
    echo ""
    echo "🌐 Your live sites:"
    for repo_name in "${repositories[@]}"; do
        echo "   https://tiaastor.github.io/$repo_name"
    done
    echo ""
    echo "Built with ❤️ and enterprise-grade standards by Tiation"
}

# Run main function
main "$@"
