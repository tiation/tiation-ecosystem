#!/bin/bash

# 🌟 Simple GitHub Pages Setup for Tiation Repositories
# Creates basic GitHub Pages configuration

echo "🌟 Setting up GitHub Pages for Tiation Repositories"
echo "Contact: tiatheone@protonmail.com"
echo ""

# List of repositories to set up GitHub Pages
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

# Process each repository
for repo in "${repositories[@]}"; do
    repo_path="/Users/tiaastor/tiation-github/$repo"
    
    if [ -d "$repo_path" ]; then
        echo "Setting up GitHub Pages for $repo..."
        cd "$repo_path" || continue
        
        # Create simple _config.yml
        cat > "_config.yml" << EOF
title: $repo
description: Enterprise-grade solution with dark neon theme
url: "https://tiaastor.github.io"
baseurl: "/$repo"
theme: minima
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag
author: Tiation
github_username: tiaastor
EOF

        # Create simple index.md
        cat > "index.md" << EOF
---
layout: default
title: $repo
---

# $repo

Enterprise-grade solution with dark neon theme and professional documentation.

## Features

- 🎯 **Enterprise Grade**: Professional-grade solution built with enterprise standards
- 🎨 **Dark Neon Theme**: Beautiful dark theme with cyan/magenta gradient accents
- 🔒 **Secure**: Built-in security features and compliance standards
- 📱 **Responsive**: Optimized for all devices and screen sizes

## Links

- [Repository](https://github.com/tiaastor/$repo)
- [Issues](https://github.com/tiaastor/$repo/issues)
- [Documentation](https://github.com/tiaastor/$repo/wiki)

## Contact

For support: [tiatheone@protonmail.com](mailto:tiatheone@protonmail.com)

---

Built with ❤️ and enterprise-grade standards by [Tiation](https://github.com/tiaastor)
EOF

        # Create Gemfile
        cat > "Gemfile" << EOF
source "https://rubygems.org"
gem "jekyll", "~> 4.3.0"
gem "minima", "~> 2.5"
gem "jekyll-feed", "~> 0.12"
gem "jekyll-sitemap"
gem "jekyll-seo-tag"
gem "github-pages", group: :jekyll_plugins
EOF

        # Commit and push
        git add _config.yml index.md Gemfile
        git commit -m "feat: setup GitHub Pages with Jekyll

- Add Jekyll configuration for GitHub Pages
- Create landing page with enterprise branding
- Include professional contact information
- Set up proper SEO and metadata"
        
        git push origin HEAD
        echo "✓ GitHub Pages setup completed for $repo"
        echo "🌐 Live demo will be available at: https://tiaastor.github.io/$repo"
        echo ""
    else
        echo "Repository not found: $repo"
    fi
done

echo "🎉 GitHub Pages setup complete!"
echo "Live demos will be available within 5-10 minutes"
echo "Built with ❤️ and enterprise-grade standards by Tiation"
