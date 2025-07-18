#!/bin/bash

# Apply Three-Site Structure to All Tiation Repositories
# Based on the Ansible pattern: Promotional, Documentation, and Parent Company

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Define repositories to process
declare -a REPOS=(
    "tiation-terminal-workflows"
    "tiation-docker-debian"
    "tiation-automation-workspace"
    "tiation-ai-platform"
    "tiation-ai-agents"
    "tiation-rigger-workspace-docs"
    "tiation-macos-networking-guide"
    "tiation-go-sdk"
    "tiation-python-sdk"
    "tiation-js-sdk"
    "tiation-java-sdk"
    "tiation-ai-code-assistant"
    "tiation-private-ai-chat"
    "tiation-cms"
    "tiation-github-pages-theme"
    "ubuntu-dev-setup"
    "tiation-secure-vpn"
    "tiation-rigger-connect-api"
    "tiation-infrastructure-charms"
    "tiation-knowledge-base-ai"
)

echo -e "${CYAN}🚀 Applying Three-Site Structure to Tiation Repositories${NC}"
echo -e "${YELLOW}Based on Ansible pattern: Promotional, Documentation, Parent Company${NC}"
echo ""

# Function to create promotional site
create_promotional_site() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/${repo_name}"
    
    echo -e "${BLUE}📄 Creating promotional site for ${repo_name}${NC}"
    
    # Create promotional directory
    mkdir -p "${repo_path}/promotional"
    
    # Create index.html
    cat > "${repo_path}/promotional/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>REPO_TITLE - Tiation</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <meta name="description" content="REPO_DESCRIPTION">
    <link rel="canonical" href="https://github.com/tiation/REPO_NAME">
    <meta property="og:title" content="REPO_TITLE">
    <meta property="og:description" content="REPO_DESCRIPTION">
    <meta property="og:url" content="https://github.com/tiation/REPO_NAME">
    <meta property="og:type" content="website">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="#home">TIATION</a>
            </div>
            <ul class="nav-menu">
                <li class="nav-item"><a href="#home" class="nav-link">Home</a></li>
                <li class="nav-item"><a href="#features" class="nav-link">Features</a></li>
                <li class="nav-item"><a href="#documentation" class="nav-link">Documentation</a></li>
                <li class="nav-item"><a href="#community" class="nav-link">Community</a></li>
                <li class="nav-item"><a href="https://github.com/tiation/REPO_NAME" class="nav-link" target="_blank">GitHub</a></li>
            </ul>
        </div>
    </nav>

    <header id="home" class="hero">
        <div class="hero-container">
            <div class="hero-content">
                <h1 class="hero-title">REPO_TITLE</h1>
                <h2 class="hero-subtitle">Enterprise-Grade Solutions</h2>
                <p class="hero-description">REPO_DESCRIPTION</p>
                <div class="hero-buttons">
                    <a href="https://github.com/tiation/REPO_NAME" class="btn btn-primary" target="_blank">View on GitHub</a>
                    <a href="../docs/index.html" class="btn btn-secondary">Documentation</a>
                </div>
            </div>
        </div>
    </header>

    <section id="features" class="features">
        <div class="container">
            <h2 class="section-title">Key Features</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">🚀</div>
                    <h3>Enterprise Ready</h3>
                    <p>Production-ready solutions with comprehensive documentation and enterprise support.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🛡️</div>
                    <h3>Security First</h3>
                    <p>Built with security best practices and compliance requirements in mind.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <h3>Performance</h3>
                    <p>Optimized for high performance and scalability in enterprise environments.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔧</div>
                    <h3>Open Source</h3>
                    <p>Fully open source with active community contributions and transparent development.</p>
                </div>
            </div>
        </div>
    </section>

    <section id="documentation" class="documentation">
        <div class="container">
            <h2 class="section-title">Documentation</h2>
            <div class="docs-grid">
                <div class="doc-card">
                    <h3>Quick Start</h3>
                    <p>Get up and running in minutes with our comprehensive quick start guide.</p>
                    <a href="https://github.com/tiation/REPO_NAME/wiki/Quick-Start" class="doc-link" target="_blank">Read More →</a>
                </div>
                <div class="doc-card">
                    <h3>API Reference</h3>
                    <p>Complete API documentation with examples and best practices.</p>
                    <a href="https://github.com/tiation/REPO_NAME/wiki/API-Reference" class="doc-link" target="_blank">Read More →</a>
                </div>
                <div class="doc-card">
                    <h3>Enterprise Guide</h3>
                    <p>Enterprise deployment and configuration guidelines.</p>
                    <a href="https://github.com/tiation/REPO_NAME/wiki/Enterprise-Guide" class="doc-link" target="_blank">Read More →</a>
                </div>
                <div class="doc-card">
                    <h3>Examples</h3>
                    <p>Working examples and code samples to get you started.</p>
                    <a href="https://github.com/tiation/REPO_NAME/tree/main/examples" class="doc-link" target="_blank">Read More →</a>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h4>Tiation</h4>
                    <p>Enterprise-grade open source solutions for modern organizations.</p>
                </div>
                <div class="footer-section">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="https://github.com/tiation/REPO_NAME" target="_blank">GitHub Repository</a></li>
                        <li><a href="https://github.com/tiation/REPO_NAME/wiki" target="_blank">Documentation</a></li>
                        <li><a href="https://github.com/tiation/REPO_NAME/issues" target="_blank">Issue Tracker</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Community</h4>
                    <ul>
                        <li><a href="https://github.com/tiation" target="_blank">Tiation GitHub</a></li>
                        <li><a href="https://github.com/tiation/REPO_NAME/discussions" target="_blank">Discussions</a></li>
                        <li><a href="https://github.com/tiation/REPO_NAME/blob/main/CONTRIBUTING.md" target="_blank">Contributing</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Tiation. Licensed under MIT. Made with ❤️ for the enterprise.</p>
            </div>
        </div>
    </footer>
</body>
</html>
EOF

    # Create style.css with dark neon theme
    cat > "${repo_path}/promotional/style.css" << 'EOF'
/* Dark Neon Theme for Tiation Enterprise Solutions */

:root {
    --primary-bg: #0a0a0a;
    --secondary-bg: #1a1a1a;
    --accent-bg: #2a2a2a;
    --text-primary: #ffffff;
    --text-secondary: #b3b3b3;
    --neon-cyan: #00ffff;
    --neon-magenta: #ff00ff;
    --neon-green: #00ff00;
    --gradient-primary: linear-gradient(135deg, var(--neon-cyan), var(--neon-magenta));
    --gradient-secondary: linear-gradient(135deg, #1a1a1a, #2a2a2a);
    --border-glow: 0 0 10px var(--neon-cyan), 0 0 20px var(--neon-cyan), 0 0 30px var(--neon-cyan);
    --text-glow: 0 0 5px var(--neon-cyan), 0 0 10px var(--neon-cyan);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Roboto', sans-serif;
    background-color: var(--primary-bg);
    color: var(--text-primary);
    line-height: 1.6;
    overflow-x: hidden;
}

/* Navigation */
.navbar {
    position: fixed;
    top: 0;
    width: 100%;
    background: rgba(10, 10, 10, 0.9);
    backdrop-filter: blur(10px);
    z-index: 1000;
    border-bottom: 1px solid var(--neon-cyan);
}

.nav-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 70px;
}

.nav-logo a {
    font-family: 'Orbitron', monospace;
    font-size: 24px;
    font-weight: 900;
    text-decoration: none;
    color: var(--text-primary);
    text-shadow: var(--text-glow);
    background: var(--gradient-primary);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.nav-menu {
    display: flex;
    list-style: none;
    gap: 30px;
}

.nav-link {
    text-decoration: none;
    color: var(--text-secondary);
    font-weight: 500;
    transition: all 0.3s ease;
    position: relative;
}

.nav-link:hover {
    color: var(--neon-cyan);
    text-shadow: var(--text-glow);
}

.nav-link::after {
    content: '';
    position: absolute;
    bottom: -5px;
    left: 0;
    width: 0;
    height: 2px;
    background: var(--gradient-primary);
    transition: width 0.3s ease;
}

.nav-link:hover::after {
    width: 100%;
}

/* Hero Section */
.hero {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--primary-bg);
    position: relative;
    overflow: hidden;
}

.hero::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
        radial-gradient(circle at 25% 25%, rgba(0, 255, 255, 0.1) 0%, transparent 50%),
        radial-gradient(circle at 75% 75%, rgba(255, 0, 255, 0.1) 0%, transparent 50%);
    pointer-events: none;
}

.hero-container {
    max-width: 1200px;
    padding: 0 20px;
    text-align: center;
    position: relative;
    z-index: 1;
}

.hero-title {
    font-family: 'Orbitron', monospace;
    font-size: 4rem;
    font-weight: 900;
    margin-bottom: 20px;
    background: var(--gradient-primary);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-shadow: var(--text-glow);
    animation: pulse 2s infinite;
}

.hero-subtitle {
    font-size: 1.5rem;
    color: var(--text-secondary);
    margin-bottom: 30px;
    font-weight: 300;
}

.hero-description {
    font-size: 1.2rem;
    color: var(--text-secondary);
    margin-bottom: 40px;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

.hero-buttons {
    display: flex;
    gap: 20px;
    justify-content: center;
    flex-wrap: wrap;
}

.btn {
    padding: 15px 30px;
    text-decoration: none;
    border-radius: 5px;
    font-weight: 500;
    transition: all 0.3s ease;
    border: 2px solid transparent;
    display: inline-block;
    position: relative;
    overflow: hidden;
}

.btn-primary {
    background: var(--gradient-primary);
    color: var(--primary-bg);
    border: 2px solid var(--neon-cyan);
}

.btn-primary:hover {
    box-shadow: var(--border-glow);
    transform: translateY(-2px);
}

.btn-secondary {
    background: transparent;
    color: var(--text-primary);
    border: 2px solid var(--neon-cyan);
}

.btn-secondary:hover {
    background: var(--neon-cyan);
    color: var(--primary-bg);
    box-shadow: var(--border-glow);
    transform: translateY(-2px);
}

/* Features Section */
.features {
    padding: 100px 0;
    background: var(--secondary-bg);
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

.section-title {
    text-align: center;
    font-family: 'Orbitron', monospace;
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 60px;
    color: var(--text-primary);
    text-shadow: var(--text-glow);
}

.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
}

.feature-card {
    background: var(--accent-bg);
    padding: 40px 30px;
    border-radius: 10px;
    text-align: center;
    border: 1px solid rgba(0, 255, 255, 0.3);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.feature-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(0, 255, 255, 0.1), transparent);
    transition: left 0.6s ease;
}

.feature-card:hover::before {
    left: 100%;
}

.feature-card:hover {
    transform: translateY(-5px);
    border-color: var(--neon-cyan);
    box-shadow: 0 10px 30px rgba(0, 255, 255, 0.2);
}

.feature-icon {
    font-size: 3rem;
    margin-bottom: 20px;
    filter: drop-shadow(0 0 10px var(--neon-cyan));
}

.feature-card h3 {
    font-family: 'Orbitron', monospace;
    font-size: 1.3rem;
    margin-bottom: 15px;
    color: var(--neon-cyan);
}

.feature-card p {
    color: var(--text-secondary);
    line-height: 1.6;
}

/* Documentation Section */
.documentation {
    padding: 100px 0;
    background: var(--primary-bg);
}

.docs-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 30px;
}

.doc-card {
    background: var(--secondary-bg);
    padding: 30px;
    border-radius: 10px;
    border: 1px solid rgba(0, 255, 255, 0.2);
    transition: all 0.3s ease;
}

.doc-card:hover {
    transform: translateY(-3px);
    border-color: var(--neon-cyan);
    box-shadow: 0 5px 20px rgba(0, 255, 255, 0.1);
}

.doc-card h3 {
    font-family: 'Orbitron', monospace;
    color: var(--neon-cyan);
    margin-bottom: 15px;
}

.doc-card p {
    color: var(--text-secondary);
    margin-bottom: 20px;
}

.doc-link {
    color: var(--neon-cyan);
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
}

.doc-link:hover {
    text-shadow: var(--text-glow);
}

/* Footer */
.footer {
    background: var(--primary-bg);
    padding: 60px 0 30px;
    border-top: 1px solid var(--neon-cyan);
}

.footer-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 40px;
    margin-bottom: 40px;
}

.footer-section h4 {
    font-family: 'Orbitron', monospace;
    color: var(--neon-cyan);
    margin-bottom: 20px;
    font-size: 1.2rem;
}

.footer-section p {
    color: var(--text-secondary);
    line-height: 1.6;
}

.footer-section ul {
    list-style: none;
}

.footer-section ul li {
    margin-bottom: 10px;
}

.footer-section ul li a {
    color: var(--text-secondary);
    text-decoration: none;
    transition: all 0.3s ease;
}

.footer-section ul li a:hover {
    color: var(--neon-cyan);
    text-shadow: var(--text-glow);
}

.footer-bottom {
    text-align: center;
    padding-top: 30px;
    border-top: 1px solid rgba(0, 255, 255, 0.2);
    color: var(--text-secondary);
}

/* Animations */
@keyframes pulse {
    0%, 100% { 
        text-shadow: var(--text-glow);
    }
    50% { 
        text-shadow: 
            0 0 5px var(--neon-cyan), 
            0 0 10px var(--neon-cyan), 
            0 0 15px var(--neon-cyan),
            0 0 20px var(--neon-cyan);
    }
}

/* Responsive Design */
@media (max-width: 768px) {
    .nav-menu {
        gap: 20px;
    }
    
    .hero-title {
        font-size: 2.5rem;
    }
    
    .hero-subtitle {
        font-size: 1.2rem;
    }
    
    .hero-description {
        font-size: 1rem;
    }
    
    .hero-buttons {
        flex-direction: column;
        align-items: center;
    }
    
    .btn {
        width: 200px;
        text-align: center;
    }
    
    .features-grid {
        grid-template-columns: 1fr;
    }
    
    .section-title {
        font-size: 2rem;
    }
}

@media (max-width: 480px) {
    .nav-container {
        padding: 0 15px;
    }
    
    .nav-menu {
        gap: 15px;
    }
    
    .nav-link {
        font-size: 0.9rem;
    }
    
    .hero-title {
        font-size: 2rem;
    }
    
    .container {
        padding: 0 15px;
    }
}
EOF

    # Replace placeholders with actual repo information
    local repo_display_name=$(echo "${repo_name}" | sed 's/tiation-//' | sed 's/-/ /g' | sed 's/\b\w/\U&/g')
    local repo_description="Enterprise-grade ${repo_display_name} solution with comprehensive documentation and professional support."
    
    sed -i '' "s/REPO_NAME/${repo_name}/g" "${repo_path}/promotional/index.html"
    sed -i '' "s/REPO_TITLE/${repo_display_name}/g" "${repo_path}/promotional/index.html"
    sed -i '' "s/REPO_DESCRIPTION/${repo_description}/g" "${repo_path}/promotional/index.html"
    
    echo -e "${GREEN}✅ Promotional site created for ${repo_name}${NC}"
}

# Function to enhance README with enterprise structure
enhance_readme() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/${repo_name}"
    
    echo -e "${BLUE}📝 Enhancing README for ${repo_name}${NC}"
    
    # Check if README exists
    if [[ ! -f "${repo_path}/README.md" ]]; then
        echo -e "${YELLOW}⚠️ README.md not found for ${repo_name}, creating basic one${NC}"
        
        local repo_display_name=$(echo "${repo_name}" | sed 's/tiation-//' | sed 's/-/ /g' | sed 's/\b\w/\U&/g')
        
        cat > "${repo_path}/README.md" << EOF
# ${repo_display_name}

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/tiation/${repo_name}.svg)](https://github.com/tiation/${repo_name}/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/tiation/${repo_name}.svg)](https://github.com/tiation/${repo_name}/issues)

Enterprise-grade ${repo_display_name} solution with comprehensive documentation and professional support.

## 🚀 Quick Start

[Add quick start instructions here]

## 📚 Documentation

- [📖 Full Documentation](https://github.com/tiation/${repo_name}/wiki)
- [🎯 Quick Start Guide](https://github.com/tiation/${repo_name}/wiki/Quick-Start)
- [📋 API Reference](https://github.com/tiation/${repo_name}/wiki/API-Reference)
- [🏢 Enterprise Guide](https://github.com/tiation/${repo_name}/wiki/Enterprise-Guide)

## 🌟 Features

- Enterprise-ready architecture
- Comprehensive documentation
- Professional support
- Open source with MIT license

## 🛠️ Installation

[Add installation instructions here]

## 📊 Usage

[Add usage examples here]

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏢 Enterprise Support

For enterprise support and consulting services, please contact us through our [GitHub organization](https://github.com/tiation).

## 🔗 Links

- [🌐 Promotional Site](promotional/index.html)
- [📚 Documentation](https://github.com/tiation/${repo_name}/wiki)
- [🐛 Issue Tracker](https://github.com/tiation/${repo_name}/issues)
- [💬 Discussions](https://github.com/tiation/${repo_name}/discussions)

---

**Made with ❤️ by [Tiation](https://github.com/tiation)**
EOF
    fi
    
    echo -e "${GREEN}✅ README enhanced for ${repo_name}${NC}"
}

# Function to create GitHub Pages configuration
create_github_pages_config() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/${repo_name}"
    
    echo -e "${BLUE}📄 Creating GitHub Pages config for ${repo_name}${NC}"
    
    # Create _config.yml for GitHub Pages
    cat > "${repo_path}/_config.yml" << EOF
# GitHub Pages Configuration for ${repo_name}

title: "${repo_name}"
description: "Enterprise-grade solutions with comprehensive documentation"
url: "https://tiation.github.io/${repo_name}"
baseurl: "/${repo_name}"

# Theme
theme: minima
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag

# SEO
author: "Tiation"
twitter:
  username: tiation
  card: summary_large_image

# Build settings
markdown: kramdown
highlighter: rouge
permalink: pretty

# Exclude from processing
exclude:
  - node_modules/
  - .cache/
  - .parcel-cache/
  - .DS_Store
  - Thumbs.db

# Include
include:
  - _pages
  - promotional

# Collections
collections:
  docs:
    output: true
    permalink: /:collection/:name/

# Default settings
defaults:
  - scope:
      path: ""
      type: "posts"
    values:
      layout: "post"
      author: "Tiation"
  - scope:
      path: ""
      type: "pages"
    values:
      layout: "page"
  - scope:
      path: ""
      type: "docs"
    values:
      layout: "doc"
EOF

    echo -e "${GREEN}✅ GitHub Pages config created for ${repo_name}${NC}"
}

# Function to create about page
create_about_page() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/${repo_name}"
    
    echo -e "${BLUE}📄 Creating about page for ${repo_name}${NC}"
    
    mkdir -p "${repo_path}/_pages"
    
    local repo_display_name=$(echo "${repo_name}" | sed 's/tiation-//' | sed 's/-/ /g' | sed 's/\b\w/\U&/g')
    
    cat > "${repo_path}/_pages/about.md" << EOF
---
layout: page
title: About
permalink: /about/
---

# About ${repo_display_name}

${repo_display_name} is part of the Tiation ecosystem of enterprise-grade open source solutions. Our mission is to provide professional, well-documented, and enterprise-ready tools that help organizations build and maintain robust systems.

## Mission

To deliver enterprise-grade open source solutions that combine professional quality with community-driven development.

## Values

- **Enterprise Quality**: Every solution is built to enterprise standards
- **Comprehensive Documentation**: Clear, detailed documentation for all users
- **Community First**: Open source with active community engagement
- **Professional Support**: Enterprise support options available

## The Tiation Ecosystem

This project is part of the larger Tiation ecosystem, which includes:

- Development tools and SDKs
- Infrastructure and automation solutions
- Security and compliance tools
- Documentation and knowledge bases

## Contact

For enterprise support and consulting services, please visit our [GitHub organization](https://github.com/tiation).

## License

This project is licensed under the MIT License, making it free for both personal and commercial use.
EOF

    echo -e "${GREEN}✅ About page created for ${repo_name}${NC}"
}

# Main processing function
process_repository() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/${repo_name}"
    
    echo -e "${PURPLE}🔄 Processing ${repo_name}...${NC}"
    
    # Check if repository exists
    if [[ ! -d "${repo_path}" ]]; then
        echo -e "${RED}❌ Repository ${repo_name} not found at ${repo_path}${NC}"
        return 1
    fi
    
    # Create promotional site
    create_promotional_site "${repo_name}"
    
    # Enhance README
    enhance_readme "${repo_name}"
    
    # Create GitHub Pages config
    create_github_pages_config "${repo_name}"
    
    # Create about page
    create_about_page "${repo_name}"
    
    echo -e "${GREEN}✅ Completed processing ${repo_name}${NC}"
    echo ""
}

# Main execution
main() {
    echo -e "${CYAN}🚀 Starting three-site structure application...${NC}"
    echo -e "${YELLOW}Processing ${#REPOS[@]} repositories...${NC}"
    echo ""
    
    for repo in "${REPOS[@]}"; do
        process_repository "${repo}"
    done
    
    echo -e "${GREEN}🎉 All repositories processed successfully!${NC}"
    echo ""
    echo -e "${CYAN}📋 Summary:${NC}"
    echo -e "  • ${GREEN}Promotional sites created${NC}"
    echo -e "  • ${GREEN}README files enhanced${NC}"
    echo -e "  • ${GREEN}GitHub Pages configured${NC}"
    echo -e "  • ${GREEN}About pages created${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. Review the generated files"
    echo -e "  2. Customize content for each repository"
    echo -e "  3. Enable GitHub Pages for each repository"
    echo -e "  4. Push changes to GitHub"
    echo ""
}

# Run main function
main "$@"
