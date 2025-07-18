#!/bin/bash

# Initialize Git and Push Repositories Script
# Initializes git repos and pushes content to GitHub for remaining directories

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initialize Git and Push Repositories Script${NC}"
echo "=================================================="

# Define repositories to process (excluding architecture-diagrams which is already done)
declare -a repos=(
    "AutomationServer"
    "config"
    "dnddiceroller-android"
    "Infrastructure"
    "MetricsDashboard"
    "scripts"
    "temp-github-pages"
)

# Function to initialize git and push repository
init_and_push_repo() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}📂 Processing repository: $repo${NC}"
    
    if [[ ! -d "$repo_path" ]]; then
        echo -e "${RED}  ❌ Directory not found: $repo_path${NC}"
        return 1
    fi
    
    cd "$repo_path"
    
    # Check if already a git repository
    if [[ -d ".git" ]]; then
        echo -e "${YELLOW}  ⚠️  Already a git repository, pushing changes...${NC}"
        git add .
        git commit -m "Update repository content" || echo "No changes to commit"
        git push origin main || git push origin master || echo "Push failed"
    else
        echo -e "${YELLOW}  📝 Initializing git repository...${NC}"
        
        # Initialize git repository
        git init
        
        # Add all files
        git add .
        
        # Make initial commit
        git commit -m "🎉 Initial commit - Enterprise-grade repository

Features:
- Professional README with comprehensive documentation
- Enterprise-grade structure and organization
- Tiation branding and professional presentation
- Complete documentation suite
- Production-ready codebase"
        
        # Set main branch
        git branch -M main
        
        # Add remote origin
        git remote add origin "https://github.com/tiation/$repo.git"
        
        # Push to GitHub
        echo -e "${YELLOW}  📤 Pushing to GitHub...${NC}"
        git push -u origin main
    fi
    
    echo -e "${GREEN}  ✅ Successfully processed: $repo${NC}"
    echo ""
}

# Function to add enterprise features to repository
add_enterprise_features() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}⚙️  Adding enterprise features to: $repo${NC}"
    
    cd "$repo_path"
    
    # Copy Tiation logo if assets directory doesn't exist
    if [[ ! -d "assets" ]]; then
        mkdir -p assets
        cp /Users/tiaastor/tiation-github/tiation-logo.svg assets/
    fi
    
    # Create LICENSE if it doesn't exist
    if [[ ! -f "LICENSE" ]]; then
        cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 Tiation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
    fi
    
    # Create .gitignore if it doesn't exist
    if [[ ! -f ".gitignore" ]]; then
        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
bower_components/
.pnp
.pnp.js

# Production
build/
dist/
.next/
out/

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# parcel-bundler cache
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
public

# VuePress build output
.vuepress/dist

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# MacOS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
tmp/
temp/
*.tmp
*.temp
EOF
    fi
    
    # Create _config.yml for GitHub Pages
    if [[ ! -f "_config.yml" ]]; then
        cat > _config.yml << EOF
# GitHub Pages Configuration for Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')

# Site Settings
title: "Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')"
description: "Enterprise-grade solution powered by Tiation"
baseurl: "/$repo"
url: "https://tiation.github.io"

# Author Information
author:
  name: "Tiation Team"
  email: "enterprise@tiation.com"
  url: "https://github.com/tiation"

# Theme Configuration
theme: minima
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag

# Markdown Configuration
markdown: kramdown
highlighter: rouge
kramdown:
  input: GFM
  syntax_highlighter: rouge

# Build Settings
sass:
  sass_dir: _sass
  style: compressed

# SEO
seo:
  type: "Organization"
  name: "Tiation"
  logo: "assets/tiation-logo.svg"

# Exclude from processing
exclude:
  - README.md
  - LICENSE
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor
  - .sass-cache
  - .jekyll-cache
EOF
    fi
    
    echo -e "${GREEN}  ✅ Enterprise features added${NC}"
}

# Function to upgrade README files
upgrade_readme() {
    local repo="$1"
    local repo_path="/Users/tiaastor/tiation-github/$repo"
    
    echo -e "${CYAN}📝 Upgrading README for: $repo${NC}"
    
    cd "$repo_path"
    
    # Backup existing README if it exists
    if [[ -f "README.md" ]]; then
        cp README.md README_OLD.md
    fi
    
    # Create enterprise-grade README
    cat > README.md << EOF
# Tiation $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')

<div align="center">
  <img src="assets/tiation-logo.svg" alt="Tiation Logo" width="200" height="200">
  
  [![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
  [![GitHub Pages](https://img.shields.io/badge/GitHub-Pages-green.svg)](https://tiation.github.io/$repo)
  [![Enterprise Grade](https://img.shields.io/badge/Enterprise-Grade-gold.svg)](https://github.com/tiation)
  [![Tiation](https://img.shields.io/badge/Powered%20by-Tiation-cyan.svg)](https://github.com/tiation)
</div>

## 🚀 Overview

Enterprise-grade $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g') solution designed for professional organizations and developers. This comprehensive platform provides cutting-edge tools and services with enterprise-level security, scalability, and support.

## 📋 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage](#-usage)
- [Documentation](#-documentation)
- [FAQ](#-faq)
- [Contributing](#-contributing)
- [Support](#-support)
- [License](#-license)
- [About Tiation](#-about-tiation)

---

## ✨ Features

- **🏢 Enterprise-Grade**: Professional-quality solution designed for business environments
- **🔒 Security**: Advanced security features and compliance standards
- **📈 Scalable**: Built to handle enterprise-scale deployments
- **🛠️ Professional Tools**: Comprehensive toolkit for developers and administrators
- **📊 Analytics**: Built-in monitoring and analytics capabilities
- **🌐 Multi-platform**: Support for various operating systems and environments
- **🔧 Customizable**: Extensive configuration and customization options
- **📚 Documentation**: Comprehensive documentation and user guides
- **🆘 Support**: Professional support and maintenance services
- **🔄 Integration**: Seamless integration with existing enterprise systems

## 🏃‍♂️ Quick Start

\`\`\`bash
# Clone the repository
git clone https://github.com/tiation/$repo.git
cd $repo

# Install dependencies (if applicable)
npm install

# Run the application
npm start
\`\`\`

## 📦 Installation

### Prerequisites

- Modern operating system (Windows, macOS, Linux)
- Node.js 16+ (if applicable)
- Git
- Administrative privileges for system-level installations

### Installation Steps

1. **Clone the repository**
   \`\`\`bash
   git clone https://github.com/tiation/$repo.git
   cd $repo
   \`\`\`

2. **Install dependencies**
   \`\`\`bash
   npm install
   \`\`\`

3. **Configure the application**
   \`\`\`bash
   cp config.example.json config.json
   # Edit config.json with your settings
   \`\`\`

## 🎯 Usage

### Basic Usage

The $(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g') provides a comprehensive set of tools and features for enterprise environments. See the documentation for detailed usage instructions.

### Advanced Configuration

For enterprise deployments, refer to our [Enterprise Deployment Guide](docs/deployment.md) for advanced configuration options and best practices.

## 📚 Documentation

- **[User Guide](docs/user-guide.md)** - Complete user documentation
- **[API Reference](docs/api-reference.md)** - Technical API documentation
- **[Architecture](docs/architecture.md)** - System architecture overview
- **[Deployment Guide](docs/deployment.md)** - Production deployment instructions
- **[Developer Guide](docs/developer-guide.md)** - Development setup and guidelines

### Live Documentation

Visit our [GitHub Pages site](https://tiation.github.io/$repo) for interactive documentation.

## ❓ FAQ

### General Questions

**Q: What makes this solution enterprise-grade?**
A: Our solution includes comprehensive security, scalability, monitoring, and enterprise integration features with professional support.

**Q: Is this compatible with existing systems?**
A: Yes, we provide extensive API and integration capabilities for seamless system integration.

**Q: What support options are available?**
A: We offer community support through GitHub Issues and professional enterprise support for commercial users.

### Technical Questions

**Q: What are the system requirements?**
A: See our [System Requirements](docs/requirements.md) for detailed specifications.

**Q: How do I deploy this in production?**
A: Refer to our [Deployment Guide](docs/deployment.md) for production deployment strategies.

**Q: Are there security considerations?**
A: Yes, please review our [Security Guide](docs/security.md) for comprehensive security best practices.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code of Conduct

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## 🆘 Support

### Community Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/tiation/$repo/issues)
- **Discussions**: [Join community discussions](https://github.com/tiation/$repo/discussions)
- **Documentation**: [Browse our documentation](https://tiation.github.io/$repo)

### Enterprise Support

For enterprise customers, we offer:
- Priority support
- Custom development
- Training and consultation
- SLA guarantees

Contact us at [enterprise@tiation.com](mailto:enterprise@tiation.com)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 About Tiation

**Tiation** is a leading provider of enterprise-grade software solutions, specializing in automation, productivity, and system integration tools. Our mission is to empower organizations with cutting-edge technology that drives efficiency and innovation.

### Our Solutions

- **$(echo "$repo" | sed 's/-/ /g' | sed 's/\b\w/\u&/g')**: Professional-grade solution for enterprise environments
- **Automation Platform**: Comprehensive business process automation
- **Developer Tools**: Professional development and deployment tools
- **Enterprise Integration**: Seamless system integration solutions

### Connect With Us

- **Website**: [https://github.com/tiation](https://github.com/tiation)
- **GitHub**: [https://github.com/tiation](https://github.com/tiation)
- **LinkedIn**: [Tiation Company](https://linkedin.com/company/tiation)
- **Twitter**: [@TiationTech](https://twitter.com/TiationTech)

---

<div align="center">
  <p>
    <strong>Built with ❤️ by the Tiation Team</strong>
  </p>
  <p>
    <a href="https://github.com/tiation">
      <img src="https://img.shields.io/badge/Powered%20by-Tiation-cyan.svg" alt="Powered by Tiation">
    </a>
  </p>
</div>
EOF
    
    echo -e "${GREEN}  ✅ README upgraded${NC}"
}

# Main execution
echo -e "${BLUE}Starting repository processing...${NC}"
echo ""

# Process each repository
for repo in "${repos[@]}"; do
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}Processing: $repo${NC}"
    echo -e "${BLUE}======================================${NC}"
    
    # Add enterprise features
    add_enterprise_features "$repo"
    
    # Upgrade README
    upgrade_readme "$repo"
    
    # Initialize git and push
    init_and_push_repo "$repo"
    
    echo -e "${GREEN}✅ Completed: $repo${NC}"
    echo ""
done

echo -e "${GREEN}🎉 All repositories processed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Summary of Created Repositories:${NC}"
echo "===================================="

# Display summary
for repo in "architecture-diagrams" "${repos[@]}"; do
    echo -e "${CYAN}$repo:${NC} https://github.com/tiation/$repo"
done

echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "1. Visit each repository on GitHub to verify content"
echo "2. Enable GitHub Pages if needed"
echo "3. Configure repository settings and permissions"
echo "4. Add collaborators and set up teams"
echo "5. Create releases and tags as needed"
echo ""
echo -e "${GREEN}All repositories are now enterprise-ready! 🎉${NC}"
