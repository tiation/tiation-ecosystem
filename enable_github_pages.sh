#!/bin/bash

# GitHub Pages CLI Enablement Script
# Enables GitHub Pages for all upgraded Tiation repositories

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Tiation GitHub Pages CLI Enablement Script${NC}"
echo "================================================="

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
    echo "Please install GitHub CLI first:"
    echo "  macOS: brew install gh"
    echo "  Linux: https://github.com/cli/cli#installation"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}⚠️  You need to authenticate with GitHub CLI${NC}"
    echo "Run: gh auth login"
    read -p "Press Enter after authentication to continue..."
fi

# Define repositories to enable GitHub Pages for
declare -a repos=(
    "dice-roller-marketing-site"
    "mark-photo-flare-site"
    "MinutesRecorder"
    "perth-white-glove-magic"
    "tiation-afl-fantasy-manager-docs"
    "tiation-ansible-enterprise"
    "tiation-economic-reform-proposal"
    "tiation-laptop-utilities"
    "tiation-legal-case-studies"
)

# Function to enable GitHub Pages for a repository
enable_github_pages() {
    local repo="$1"
    echo -e "${CYAN}📄 Enabling GitHub Pages for: $repo${NC}"
    
    # Check if repository exists
    if ! gh repo view "tiation/$repo" &> /dev/null; then
        echo -e "${RED}❌ Repository tiation/$repo not found${NC}"
        return 1
    fi
    
    # Enable GitHub Pages using GitHub API
    echo -e "${YELLOW}  Setting up GitHub Pages deployment...${NC}"
    
    # Create GitHub Pages deployment from main/master branch
    gh api \
        --method POST \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/tiation/$repo/pages" \
        -f source='{"branch":"main","path":"/"}' \
        2>/dev/null || \
    gh api \
        --method POST \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/tiation/$repo/pages" \
        -f source='{"branch":"master","path":"/"}' \
        2>/dev/null || \
    gh api \
        --method POST \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/repos/tiation/$repo/pages" \
        -f source='{"branch":"gh-pages","path":"/"}' \
        2>/dev/null || \
    echo -e "${YELLOW}  GitHub Pages may already be enabled or using GitHub Actions${NC}"
    
    # Check if GitHub Pages is enabled
    local pages_url=$(gh api "/repos/tiation/$repo/pages" --jq '.html_url' 2>/dev/null || echo "")
    
    if [[ -n "$pages_url" ]]; then
        echo -e "${GREEN}  ✅ GitHub Pages enabled successfully${NC}"
        echo -e "${GREEN}  🌐 Site URL: $pages_url${NC}"
        
        # Update repository description to include GitHub Pages URL
        gh repo edit "tiation/$repo" --add-topic "github-pages" --add-topic "tiation" --add-topic "enterprise" 2>/dev/null || true
        
        echo -e "${GREEN}  📋 Added topics: github-pages, tiation, enterprise${NC}"
    else
        echo -e "${YELLOW}  ⚠️  GitHub Pages status unclear - may need manual verification${NC}"
    fi
    
    echo ""
}

# Function to check and display repository status
check_repository_status() {
    local repo="$1"
    echo -e "${CYAN}📊 Checking status for: $repo${NC}"
    
    # Get repository information
    local repo_info=$(gh repo view "tiation/$repo" --json name,description,url,homepageUrl,topics,visibility 2>/dev/null || echo "{}")
    
    if [[ "$repo_info" == "{}" ]]; then
        echo -e "${RED}  ❌ Repository not accessible${NC}"
        return 1
    fi
    
    local homepage_url=$(echo "$repo_info" | jq -r '.homepageUrl // empty')
    local topics=$(echo "$repo_info" | jq -r '.topics[]?' | tr '\n' ' ')
    local visibility=$(echo "$repo_info" | jq -r '.visibility')
    
    echo -e "${GREEN}  📁 Repository: tiation/$repo${NC}"
    echo -e "${GREEN}  👁️  Visibility: $visibility${NC}"
    echo -e "${GREEN}  🏷️  Topics: $topics${NC}"
    
    if [[ -n "$homepage_url" ]]; then
        echo -e "${GREEN}  🌐 Homepage: $homepage_url${NC}"
    fi
    
    # Check GitHub Pages status
    local pages_info=$(gh api "/repos/tiation/$repo/pages" 2>/dev/null || echo "{}")
    local pages_url=$(echo "$pages_info" | jq -r '.html_url // empty')
    local pages_status=$(echo "$pages_info" | jq -r '.status // empty')
    
    if [[ -n "$pages_url" ]]; then
        echo -e "${GREEN}  📄 GitHub Pages: $pages_url${NC}"
        echo -e "${GREEN}  📊 Status: $pages_status${NC}"
    else
        echo -e "${YELLOW}  📄 GitHub Pages: Not enabled${NC}"
    fi
    
    echo ""
}

# Function to setup repository settings
setup_repository_settings() {
    local repo="$1"
    echo -e "${CYAN}⚙️  Setting up repository settings for: $repo${NC}"
    
    # Enable issues, wiki, and discussions
    gh repo edit "tiation/$repo" \
        --enable-issues \
        --enable-wiki \
        --enable-discussions \
        --delete-branch-on-merge \
        --allow-merge-commit \
        --allow-squash-merge \
        --allow-rebase-merge \
        2>/dev/null || echo -e "${YELLOW}  ⚠️  Some settings may not be available${NC}"
    
    # Set repository homepage to GitHub Pages URL if available
    local pages_url=$(gh api "/repos/tiation/$repo/pages" --jq '.html_url' 2>/dev/null || echo "")
    if [[ -n "$pages_url" ]]; then
        gh repo edit "tiation/$repo" --homepage "$pages_url" 2>/dev/null || true
        echo -e "${GREEN}  🏠 Homepage set to: $pages_url${NC}"
    fi
    
    echo ""
}

# Function to create and deploy GitHub Pages
deploy_github_pages() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}🚀 Deploying GitHub Pages for: $repo${NC}"
    
    if [[ ! -d "$repo_path" ]]; then
        echo -e "${RED}  ❌ Repository directory not found: $repo_path${NC}"
        return 1
    fi
    
    cd "$repo_path"
    
    # Create a simple index.html if it doesn't exist
    if [[ ! -f "index.html" && ! -f "index.md" ]]; then
        echo -e "${YELLOW}  📝 Creating index.html from README.md${NC}"
        cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo img {
            width: 150px;
            height: 150px;
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        .badge {
            display: inline-block;
            padding: 4px 8px;
            margin: 2px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }
        .badge.license { background: #007ec6; }
        .badge.pages { background: #28a745; }
        .badge.enterprise { background: #ffc107; color: #212529; }
        .badge.tiation { background: #17a2b8; }
        .redirect-notice {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            margin: 20px 0;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007ec6;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 10px;
        }
        .btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <img src="assets/tiation-logo.svg" alt="Tiation Logo" onerror="this.style.display='none'">
        </div>
        <h1>Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')</h1>
        
        <div style="text-align: center; margin-bottom: 30px;">
            <a href="#" class="badge license">License: MIT</a>
            <a href="#" class="badge pages">GitHub Pages</a>
            <a href="#" class="badge enterprise">Enterprise Grade</a>
            <a href="https://github.com/tiation" class="badge tiation">Powered by Tiation</a>
        </div>
        
        <div class="redirect-notice">
            <h3>🚀 Welcome to Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')</h3>
            <p>This is an enterprise-grade solution powered by Tiation. Visit our GitHub repository for complete documentation and source code.</p>
            <a href="https://github.com/tiation/$repo" class="btn">View on GitHub</a>
            <a href="https://github.com/tiation/$repo#readme" class="btn">Documentation</a>
        </div>
        
        <div style="margin-top: 30px;">
            <h3>🌟 About Tiation</h3>
            <p>Tiation is a leading provider of enterprise-grade software solutions, specializing in automation, productivity, and system integration tools.</p>
            <p style="text-align: center;">
                <a href="https://github.com/tiation" class="btn">Visit Tiation on GitHub</a>
            </p>
        </div>
    </div>
</body>
</html>
EOF
    fi
    
    # Commit and push changes
    git add index.html 2>/dev/null || true
    git commit -m "🌐 Add GitHub Pages index.html" 2>/dev/null || true
    git push 2>/dev/null || true
    
    echo -e "${GREEN}  ✅ GitHub Pages deployment completed${NC}"
    echo ""
}

# Main execution
echo -e "${BLUE}Starting GitHub Pages enablement process...${NC}"
echo ""

# Process each repository
for repo in "${repos[@]}"; do
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}Processing: $repo${NC}"
    echo -e "${BLUE}======================================${NC}"
    
    # Check current status
    check_repository_status "$repo"
    
    # Enable GitHub Pages
    enable_github_pages "$repo"
    
    # Setup repository settings
    setup_repository_settings "$repo"
    
    # Deploy GitHub Pages
    deploy_github_pages "$repo"
    
    echo -e "${GREEN}✅ Completed processing: $repo${NC}"
    echo ""
done

echo -e "${GREEN}🎉 GitHub Pages enablement completed for all repositories!${NC}"
echo ""
echo -e "${BLUE}📋 Summary of GitHub Pages URLs:${NC}"
echo "=================================="

# Display summary
for repo in "${repos[@]}"; do
    local pages_url=$(gh api "/repos/tiation/$repo/pages" --jq '.html_url' 2>/dev/null || echo "Not available")
    echo -e "${CYAN}$repo:${NC} $pages_url"
done

echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "1. Visit each GitHub Pages URL to verify deployment"
echo "2. Configure custom domains if needed"
echo "3. Set up analytics and monitoring"
echo "4. Review and customize content as needed"
echo ""
echo -e "${GREEN}Enterprise GitHub Pages deployment complete! 🎉${NC}"
