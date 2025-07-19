#!/bin/bash

# Universal GitHub Pages Setup Script
# This script sets up GitHub Pages for any repository with docs/ directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to create Jekyll configuration
create_jekyll_config() {
    local repo_name="$1"
    local repo_title="$2"
    local repo_description="$3"
    
    cat > "_config.yml" << EOF
# Site settings
title: "${repo_title}"
description: "${repo_description}"
url: "https://tiation.github.io"
baseurl: "/${repo_name}"

# GitHub Pages settings
source: "."
destination: "_site"
plugins:
  - jekyll-feed
  - jekyll-sitemap
  - jekyll-seo-tag

# Theme and styling
theme: minima
markdown: kramdown
highlighter: rouge

# Navigation
nav_links:
  - name: "Home"
    link: "/"
  - name: "Documentation"
    link: "/docs/"
  - name: "GitHub"
    link: "https://github.com/tiation/${repo_name}"

# Site configuration
permalink: pretty
timezone: Australia/Perth

# Collections
collections:
  docs:
    output: true
    permalink: /:collection/:name/

# Defaults
defaults:
  - scope:
      path: ""
      type: "docs"
    values:
      layout: "page"
  - scope:
      path: ""
      type: "pages"
    values:
      layout: "page"

# SEO
author: "Tiation"
email: "tiatheone@protonmail.com"
github_username: "tiation"

# Social
social:
  - name: "GitHub"
    icon: "fab fa-github"
    link: "https://github.com/tiation"

# Exclude from processing
exclude:
  - README.md
  - node_modules
  - package.json
  - package-lock.json
  - .git
  - .github
  - "*.sh"
  - "*.py"
  - vendor
  - .bundle
  - .sass-cache
  - .jekyll-cache
  - .jekyll-metadata
EOF
}

# Function to create GitHub Actions workflow
create_github_actions() {
    mkdir -p ".github/workflows"
    
    cat > ".github/workflows/pages.yml" << EOF
name: Deploy Jekyll site to Pages

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
          cache-version: 0
      
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v4
      
      - name: Build with Jekyll
        run: |
          bundle exec jekyll build --baseurl "\${{ steps.pages.outputs.base_path }}"
        env:
          JEKYLL_ENV: production
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3

  deploy:
    environment:
      name: github-pages
      url: \${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF
}

# Function to create Gemfile
create_gemfile() {
    cat > "Gemfile" << EOF
source "https://rubygems.org"

gem "jekyll", "~> 4.3.2"
gem "minima", "~> 2.5"

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-sitemap", "~> 1.4"
  gem "jekyll-seo-tag", "~> 2.8"
end

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
gem "github-pages", group: :jekyll_plugins
EOF
}

# Function to create dark neon CSS
create_dark_neon_css() {
    mkdir -p "assets/css"
    
    cat > "assets/css/style.scss" << EOF
---
---

@import "minima";

// Tiation Dark Neon Theme
:root {
  --primary-color: #00ffff;
  --secondary-color: #ff00ff;
  --background-color: #0a0a0a;
  --text-color: #ffffff;
  --accent-color: #00ff88;
  --card-background: rgba(26, 26, 46, 0.8);
  --border-color: rgba(0, 255, 255, 0.3);
}

body {
  background: linear-gradient(135deg, #0a0a0a 0%, #1a1a2e 50%, #16213e 100%);
  color: var(--text-color);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  min-height: 100vh;
}

// Animated background
body::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at 20% 20%, rgba(0, 255, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(255, 0, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 60% 40%, rgba(0, 255, 65, 0.1) 0%, transparent 50%);
  animation: pulse 4s ease-in-out infinite alternate;
  z-index: -1;
}

@keyframes pulse {
  0% { opacity: 0.3; }
  100% { opacity: 0.6; }
}

// Header styling
.site-header {
  background: rgba(10, 10, 10, 0.9);
  backdrop-filter: blur(10px);
  border-bottom: 2px solid var(--primary-color);
  box-shadow: 0 2px 20px rgba(0, 255, 255, 0.3);
}

.site-title {
  background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: bold;
  text-shadow: 0 0 10px var(--primary-color);
}

.site-title:hover {
  animation: glow 1s ease-in-out infinite alternate;
}

@keyframes glow {
  from { filter: brightness(1); }
  to { filter: brightness(1.5); }
}

// Navigation
.site-nav {
  .page-link {
    color: var(--text-color);
    transition: all 0.3s ease;
    
    &:hover {
      color: var(--primary-color);
      text-shadow: 0 0 10px var(--primary-color);
    }
  }
}

// Main content
.page-content {
  background: transparent;
}

.wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

// Cards and content blocks
.post, .page-content .wrapper {
  background: var(--card-background);
  border: 1px solid var(--border-color);
  border-radius: 10px;
  padding: 30px;
  margin: 20px 0;
  box-shadow: 0 5px 20px rgba(0, 255, 255, 0.1);
  backdrop-filter: blur(5px);
}

// Headings
h1, h2, h3, h4, h5, h6 {
  color: var(--text-color);
  background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 20px;
}

// Links
a {
  color: var(--primary-color);
  text-decoration: none;
  transition: all 0.3s ease;
  
  &:hover {
    color: var(--accent-color);
    text-shadow: 0 0 10px var(--accent-color);
  }
}

// Code blocks
pre, code {
  background: rgba(0, 0, 0, 0.5);
  border: 1px solid var(--border-color);
  border-radius: 5px;
  color: var(--accent-color);
}

// Buttons
.btn, button {
  background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
  color: var(--background-color);
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(0, 255, 255, 0.3);
  }
}

// Footer
.site-footer {
  background: rgba(10, 10, 10, 0.9);
  border-top: 2px solid var(--primary-color);
  color: var(--text-color);
  
  .footer-heading {
    color: var(--primary-color);
  }
}

// Responsive design
@media (max-width: 768px) {
  .wrapper {
    padding: 0 15px;
  }
  
  .post, .page-content .wrapper {
    padding: 20px;
    margin: 10px 0;
  }
}
EOF
}

# Function to create docs structure if missing
create_docs_structure() {
    if [ ! -d "docs" ]; then
        print_status "Creating docs directory structure..."
        mkdir -p docs
    fi
    
    # Create index.md if it doesn't exist
    if [ ! -f "docs/index.md" ]; then
        cat > "docs/index.md" << EOF
---
layout: page
title: Documentation
---

# Documentation

Welcome to the documentation for this project.

## Quick Start

Get started with this project quickly.

## Features

- Enterprise-grade documentation
- Dark neon theme
- Responsive design
- GitHub integration

## Support

For support, please visit our [GitHub repository](https://github.com/tiation/$(basename $(pwd))).
EOF
    fi
}

# Function to setup GitHub Pages for a repository
setup_github_pages() {
    local repo_dir="$1"
    local repo_name=$(basename "$repo_dir")
    
    print_status "Setting up GitHub Pages for: $repo_name"
    
    # Change to repository directory
    cd "$repo_dir"
    
    # Check if it's a git repository
    if [ ! -d ".git" ]; then
        print_warning "Skipping $repo_name - not a git repository"
        return 1
    fi
    
    # Generate title and description
    local repo_title="Tiation $(echo $repo_name | sed 's/-/ /g' | sed 's/\b\w/\u&/g')"
    local repo_description="Enterprise-grade $(echo $repo_name | sed 's/-/ /g') with dark neon interface"
    
    print_status "Creating Jekyll configuration..."
    create_jekyll_config "$repo_name" "$repo_title" "$repo_description"
    
    print_status "Creating GitHub Actions workflow..."
    create_github_actions
    
    print_status "Creating Gemfile..."
    create_gemfile
    
    print_status "Creating dark neon CSS theme..."
    create_dark_neon_css
    
    print_status "Setting up documentation structure..."
    create_docs_structure
    
    # Commit changes
    print_status "Committing GitHub Pages configuration..."
    git add .
    git commit -m "Add GitHub Pages configuration with dark neon theme" || true
    
    print_success "GitHub Pages setup complete for $repo_name"
    print_status "Site will be available at: https://tiation.github.io/$repo_name"
    
    return 0
}

# Main script execution
main() {
    print_status "Starting Universal GitHub Pages Setup..."
    
    # Check if we're in the tiation-github directory
    if [ ! -d "/Users/tiaastor/tiation-github" ]; then
        print_error "tiation-github directory not found!"
        exit 1
    fi
    
    cd "/Users/tiaastor/tiation-github"
    
    # Counter for statistics
    local total_repos=0
    local setup_repos=0
    local skipped_repos=0
    
    # Process each directory
    for repo_dir in */; do
        if [ -d "$repo_dir" ]; then
            total_repos=$((total_repos + 1))
            
            # Skip certain directories
            case "$repo_dir" in
                ".git/"|"node_modules/"|"_site/")
                    continue
                    ;;
            esac
            
            if setup_github_pages "$repo_dir"; then
                setup_repos=$((setup_repos + 1))
            else
                skipped_repos=$((skipped_repos + 1))
            fi
            
            # Return to base directory
            cd "/Users/tiaastor/tiation-github"
        fi
    done
    
    # Print summary
    echo ""
    print_success "GitHub Pages Setup Complete!"
    print_status "Total repositories: $total_repos"
    print_status "Successfully configured: $setup_repos"
    print_status "Skipped: $skipped_repos"
    echo ""
    print_status "Next steps:"
    echo "1. Push all repositories to GitHub"
    echo "2. Enable GitHub Pages in each repository settings"
    echo "3. Set source to 'GitHub Actions' in Pages settings"
    echo ""
    print_status "All sites will use the dark neon theme with cyan gradients"
}

# Run the main function
main "$@"
