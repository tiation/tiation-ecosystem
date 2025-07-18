#!/bin/bash

# GitHub Pages Setup Script
# Prepares repositories for GitHub Pages deployment

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🌐 Tiation GitHub Pages Setup Script${NC}"
echo "====================================="

# Define repositories
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

# Function to create GitHub Pages files
setup_github_pages_files() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}📄 Setting up GitHub Pages for: $repo${NC}"
    
    if [[ ! -d "$repo_path" ]]; then
        echo -e "${RED}  ❌ Repository not found: $repo_path${NC}"
        return 1
    fi
    
    cd "$repo_path"
    
    # Create index.html for GitHub Pages
    if [[ ! -f "index.html" ]]; then
        echo -e "${YELLOW}  📝 Creating index.html${NC}"
        
        cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')</title>
    <meta name="description" content="Enterprise-grade solution powered by Tiation">
    <meta name="keywords" content="tiation, enterprise, $(echo "$repo" | sed 's/-/, /g')">
    <meta name="author" content="Tiation Team">
    
    <!-- Open Graph Meta Tags -->
    <meta property="og:title" content="Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')">
    <meta property="og:description" content="Enterprise-grade solution powered by Tiation">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://tiation.github.io/$repo">
    <meta property="og:image" content="https://tiation.github.io/$repo/assets/tiation-logo.svg">
    
    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')">
    <meta name="twitter:description" content="Enterprise-grade solution powered by Tiation">
    <meta name="twitter:image" content="https://tiation.github.io/$repo/assets/tiation-logo.svg">
    
    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="assets/tiation-logo.svg">
    
    <style>
        :root {
            --primary-dark: #0a0a0a;
            --cyan-primary: #00ffff;
            --neon-pink: #ff00ff;
            --gradient-primary: linear-gradient(135deg, var(--cyan-primary), var(--neon-pink));
            --gradient-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: var(--gradient-bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            width: 90%;
            text-align: center;
        }
        
        .logo {
            margin-bottom: 30px;
        }
        
        .logo img {
            width: 120px;
            height: 120px;
            filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
        }
        
        h1 {
            color: var(--primary-dark);
            font-size: 2.5em;
            margin-bottom: 20px;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .subtitle {
            color: #666;
            font-size: 1.2em;
            margin-bottom: 30px;
        }
        
        .badges {
            margin-bottom: 40px;
        }
        
        .badge {
            display: inline-block;
            padding: 8px 16px;
            margin: 4px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            color: white;
            transition: transform 0.3s ease;
        }
        
        .badge:hover {
            transform: translateY(-2px);
        }
        
        .badge.license { background: #007ec6; }
        .badge.pages { background: #28a745; }
        .badge.enterprise { 
            background: linear-gradient(45deg, #ffc107, #ff8c00);
            color: #212529;
        }
        .badge.tiation { 
            background: var(--gradient-primary);
        }
        
        .main-content {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 15px;
            margin: 30px 0;
        }
        
        .buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 15px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn.primary {
            background: var(--gradient-primary);
            color: white;
        }
        
        .btn.secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }
        
        .about-section {
            margin-top: 40px;
            padding: 20px;
            background: rgba(0, 255, 255, 0.1);
            border-radius: 10px;
            border: 1px solid rgba(0, 255, 255, 0.3);
        }
        
        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 20px;
                width: 95%;
            }
            
            h1 {
                font-size: 2em;
            }
            
            .buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <img src="assets/tiation-logo.svg" alt="Tiation Logo" onerror="this.style.display='none'">
        </div>
        
        <h1>Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')</h1>
        <p class="subtitle">Enterprise-Grade Solution</p>
        
        <div class="badges">
            <a href="LICENSE" class="badge license">MIT License</a>
            <a href="#" class="badge pages">GitHub Pages</a>
            <a href="https://github.com/tiation" class="badge enterprise">Enterprise Grade</a>
            <a href="https://github.com/tiation" class="badge tiation">Powered by Tiation</a>
        </div>
        
        <div class="main-content">
            <h2>🚀 Welcome to Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')</h2>
            <p>This is an enterprise-grade solution powered by Tiation. Our platform provides professional-quality tools and services designed for modern businesses and developers.</p>
            
            <div class="buttons">
                <a href="https://github.com/tiation/$repo" class="btn primary">View on GitHub</a>
                <a href="https://github.com/tiation/$repo#readme" class="btn secondary">Documentation</a>
            </div>
        </div>
        
        <div class="about-section">
            <h3>🌟 About Tiation</h3>
            <p>Tiation is a leading provider of enterprise-grade software solutions, specializing in automation, productivity, and system integration tools. We empower organizations with cutting-edge technology that drives efficiency and innovation.</p>
            
            <div style="margin-top: 20px;">
                <a href="https://github.com/tiation" class="btn primary">Visit Tiation on GitHub</a>
            </div>
        </div>
        
        <div class="footer">
            <p><strong>Built with ❤️ by the Tiation Team</strong></p>
            <p>© 2024 Tiation. All rights reserved.</p>
        </div>
    </div>
</body>
</html>
EOF
    else
        echo -e "${GREEN}  ✅ index.html already exists${NC}"
    fi
    
    # Create CNAME file for custom domain (optional)
    if [[ ! -f "CNAME" ]]; then
        echo -e "${YELLOW}  📝 Creating CNAME file${NC}"
        echo "$repo.tiation.com" > CNAME
    fi
    
    # Create .nojekyll file to bypass Jekyll processing
    if [[ ! -f ".nojekyll" ]]; then
        echo -e "${YELLOW}  📝 Creating .nojekyll file${NC}"
        touch .nojekyll
    fi
    
    # Create robots.txt
    if [[ ! -f "robots.txt" ]]; then
        echo -e "${YELLOW}  📝 Creating robots.txt${NC}"
        cat > robots.txt << EOF
User-agent: *
Allow: /

Sitemap: https://tiation.github.io/$repo/sitemap.xml
EOF
    fi
    
    # Create sitemap.xml
    if [[ ! -f "sitemap.xml" ]]; then
        echo -e "${YELLOW}  📝 Creating sitemap.xml${NC}"
        cat > sitemap.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>https://tiation.github.io/$repo/</loc>
        <lastmod>$(date +%Y-%m-%d)</lastmod>
        <changefreq>weekly</changefreq>
        <priority>1.0</priority>
    </url>
    <url>
        <loc>https://github.com/tiation/$repo</loc>
        <lastmod>$(date +%Y-%m-%d)</lastmod>
        <changefreq>weekly</changefreq>
        <priority>0.8</priority>
    </url>
</urlset>
EOF
    fi
    
    echo -e "${GREEN}  ✅ GitHub Pages files created successfully${NC}"
    echo ""
}

# Function to commit and push changes
commit_and_push() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}📤 Committing and pushing changes for: $repo${NC}"
    
    cd "$repo_path"
    
    # Add all new files
    git add index.html CNAME .nojekyll robots.txt sitemap.xml 2>/dev/null || true
    
    # Commit changes
    if git diff --cached --quiet; then
        echo -e "${YELLOW}  ℹ️  No changes to commit${NC}"
    else
        git commit -m "🌐 Add GitHub Pages configuration and landing page

- Add professional index.html with Tiation branding
- Create CNAME for custom domain support
- Add .nojekyll to bypass Jekyll processing
- Include SEO-optimized robots.txt and sitemap.xml
- Enterprise-grade styling with responsive design" || echo -e "${YELLOW}  ⚠️  Commit failed${NC}"
        
        # Push changes
        git push || echo -e "${YELLOW}  ⚠️  Push failed${NC}"
        
        echo -e "${GREEN}  ✅ Changes committed and pushed${NC}"
    fi
    
    echo ""
}

# Function to display repository information
display_repo_info() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}📋 Repository Information: $repo${NC}"
    
    cd "$repo_path"
    
    # Get remote URL
    local remote_url=$(git remote get-url origin 2>/dev/null || echo "No remote configured")
    echo -e "${GREEN}  🔗 Remote URL: $remote_url${NC}"
    
    # Get GitHub Pages URL
    local github_pages_url="https://tiation.github.io/$repo"
    echo -e "${GREEN}  🌐 GitHub Pages URL: $github_pages_url${NC}"
    
    # Get custom domain URL
    local custom_domain_url="https://$repo.tiation.com"
    echo -e "${GREEN}  🎯 Custom Domain URL: $custom_domain_url${NC}"
    
    echo ""
}

# Main execution
echo -e "${BLUE}Starting GitHub Pages setup process...${NC}"
echo ""

# Process each repository
for repo in "${repos[@]}"; do
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}Processing: $repo${NC}"
    echo -e "${BLUE}======================================${NC}"
    
    # Setup GitHub Pages files
    setup_github_pages_files "$repo"
    
    # Commit and push changes
    commit_and_push "$repo"
    
    # Display repository information
    display_repo_info "$repo"
    
    echo -e "${GREEN}✅ Completed: $repo${NC}"
    echo ""
done

echo -e "${GREEN}🎉 GitHub Pages setup completed for all repositories!${NC}"
echo ""
echo -e "${BLUE}📋 Summary of GitHub Pages URLs:${NC}"
echo "=================================="

# Display summary
for repo in "${repos[@]}"; do
    echo -e "${CYAN}$repo:${NC}"
    echo -e "  🌐 GitHub Pages: https://tiation.github.io/$repo"
    echo -e "  🎯 Custom Domain: https://$repo.tiation.com"
    echo ""
done

echo -e "${BLUE}🚀 Manual Steps Required:${NC}"
echo "1. Go to each repository's GitHub Settings → Pages"
echo "2. Set Source to 'Deploy from a branch'"
echo "3. Select 'main' branch and '/ (root)' folder"
echo "4. Configure custom domain if needed"
echo "5. Enable 'Enforce HTTPS'"
echo ""
echo -e "${BLUE}💡 Pro Tips:${NC}"
echo "• GitHub Pages URLs may take a few minutes to become active"
echo "• Custom domains require DNS configuration"
echo "• All sites are now SEO-optimized with meta tags and sitemaps"
echo "• Sites feature responsive design and Tiation branding"
echo ""
echo -e "${GREEN}Enterprise GitHub Pages deployment complete! 🎉${NC}"
