#!/bin/bash

# Tiation GitHub Enterprise File Organization Script
# This script organizes the tiation-github directory into an enterprise-grade structure
# Following dark neon theme and mobile-first principles

set -e  # Exit on any error

# Color definitions for dark neon theme terminal output
CYAN='\033[0;96m'
MAGENTA='\033[0;95m'
GREEN='\033[0;92m'
YELLOW='\033[0;93m'
RED='\033[0;91m'
NC='\033[0m' # No Color

# Base directory
BASE_DIR="/Users/tiaastor/tiation-github"
cd "$BASE_DIR"

echo -e "${CYAN}🚀 Tiation GitHub Enterprise File Organization${NC}"
echo -e "${MAGENTA}Implementing enterprise-grade structure...${NC}"

# Create the new directory structure
echo -e "${YELLOW}📁 Creating directory structure...${NC}"

# Main directories
mkdir -p automation/{python,shell,workflows}
mkdir -p templates/{config,documentation,web,workflows}
mkdir -p documentation/{guides,reports,architecture,api}
mkdir -p assets/{images,svg,branding}
mkdir -p infrastructure/{docker,deployment,monitoring}
mkdir -p tools/utilities
mkdir -p archive

echo -e "${GREEN}✅ Directory structure created${NC}"

# Function to move file if it exists
move_file() {
    local src="$1"
    local dest="$2"
    if [[ -f "$src" ]]; then
        echo -e "${CYAN}Moving: $src → $dest${NC}"
        mv "$src" "$dest"
    else
        echo -e "${YELLOW}⚠️  File not found: $src${NC}"
    fi
}

# Migrate Templates
echo -e "${MAGENTA}📋 Migrating templates...${NC}"
move_file ".pre-commit-config-template.yaml" "templates/config/"
move_file ".env.example-template" "templates/config/"
move_file ".gitignore-template" "templates/config/"
move_file ".eslintrc-template.js" "templates/config/"
move_file ".prettierrc-template.js" "templates/config/"
move_file ".github-workflow-template.yml" "templates/workflows/"
move_file "universal_sales_template.html" "templates/web/"
move_file "enterprise_readme_template.md" "templates/documentation/"
move_file "README_TEMPLATE.md" "templates/documentation/"
move_file "API_DOCS_TEMPLATE.md" "templates/documentation/"

# Migrate Python Scripts
echo -e "${MAGENTA}🐍 Migrating Python automation scripts...${NC}"
find . -maxdepth 1 -name "*.py" -exec mv {} automation/python/ \;

# Migrate Shell Scripts
echo -e "${MAGENTA}⚡ Migrating Shell scripts...${NC}"
find . -maxdepth 1 -name "*.sh" ! -name "organize_enterprise_structure.sh" -exec mv {} automation/shell/ \;

# Migrate Documentation Files
echo -e "${MAGENTA}📚 Migrating documentation...${NC}"

# Reports
move_file "coherence_report.json" "documentation/reports/"
move_file "mass-upgrade.log" "documentation/reports/"
move_file "cross-reference-summary.md" "documentation/reports/"
move_file "deployment-configuration-report.md" "documentation/reports/"
move_file "DOCUMENTATION_ENHANCEMENT_REPORT.md" "documentation/reports/"
move_file "ENTERPRISE_UPGRADE_SUMMARY.md" "documentation/reports/"
move_file "GITHUB_PAGES_STATUS.md" "documentation/reports/"
move_file "GITHUB_REPOS_CREATION_SUMMARY.md" "documentation/reports/"
move_file "REPOSITORY_ENHANCEMENT_SUMMARY.md" "documentation/reports/"
move_file "rigger-hub-test-results.md" "documentation/reports/"
move_file "SYNC_REPORT.md" "documentation/reports/"
move_file "TEST_SUMMARY.md" "documentation/reports/"
move_file "THREE_SITE_STRUCTURE_REPORT.md" "documentation/reports/"
move_file "UNIVERSAL_DOCS_ENHANCEMENT_REPORT.md" "documentation/reports/"
move_file "UNIVERSAL_DOCS_PUSH_REPORT.md" "documentation/reports/"
move_file "VALIDATION_REPORT.md" "documentation/reports/"
move_file "COHERENCE_SUMMARY.md" "documentation/reports/"
move_file "PERFECT_COHERENCE_ACHIEVED.md" "documentation/reports/"

# Guides
move_file "AGENT_BRIEFING_CHECKLIST.md" "documentation/guides/"
move_file "AGENT_QUICK_REFERENCE.md" "documentation/guides/"
move_file "dependency-management.md" "documentation/guides/"
move_file "enterprise-upgrade-plan.md" "documentation/guides/"
move_file "GITHUB_PAGES_SETUP_INSTRUCTIONS.md" "documentation/guides/"
move_file "GITHUB_PINNING_GUIDE.md" "documentation/guides/"
move_file "iOS_SETUP_GUIDE.md" "documentation/guides/"
move_file "monetization-implementation-checklist.md" "documentation/guides/"
move_file "monetization-strategy.md" "documentation/guides/"
move_file "MVP_STRATEGY_PLAN.md" "documentation/guides/"
move_file "pinned-repos-enhancement-plan.md" "documentation/guides/"
move_file "PINNING_GUIDE_INTERACTIVE.md" "documentation/guides/"
move_file "PINNING_QUICK_REFERENCE.md" "documentation/guides/"
move_file "QUICK_PIN_REFERENCE.md" "documentation/guides/"
move_file "TIATION_AGENT_DEPLOYMENT_GUIDE.md" "documentation/guides/"
move_file "TIATION_VALUE_ENHANCEMENT_PROPOSALS.md" "documentation/guides/"

# Architecture
move_file "AI_AGENT_CONTEXT.md" "documentation/architecture/"
move_file "DOCUMENTATION_STRUCTURE.md" "documentation/architecture/"
move_file "ECOSYSTEM_CONNECTIVITY.md" "documentation/architecture/"
move_file "INFRASTRUCTURE_DOCUMENTATION.md" "documentation/architecture/"
move_file "REPOSITORY_GRAPH.md" "documentation/architecture/"
move_file "REPOSITORY_INDEX.md" "documentation/architecture/"
move_file "RIGGER_PROJECT_OVERVIEW.md" "documentation/architecture/"

# Assets
echo -e "${MAGENTA}🎨 Migrating assets...${NC}"
move_file "tiation-logo.svg" "assets/branding/"

# Infrastructure
echo -e "${MAGENTA}🏗️  Migrating infrastructure files...${NC}"
move_file "Caddyfile" "infrastructure/deployment/"

# Special files (keep in root or move to appropriate location)
echo -e "${MAGENTA}📝 Handling special files...${NC}"
# Keep README.md in root but backup the old one
if [[ -f "README.md.backup" ]]; then
    mv "README.md.backup" "archive/"
fi

# Configuration files that should stay in root
echo -e "${YELLOW}📋 Configuration files staying in root:${NC}"
echo -e "${CYAN}.ai-context, .aiagent-rules, .gitignore${NC}"

# Create a comprehensive README for the new structure
echo -e "${MAGENTA}📖 Creating enterprise README...${NC}"

cat > "README.md" << 'EOF'
# 🌌 Tiation GitHub Enterprise Workspace

<div align="center">

![Tiation Logo](assets/branding/tiation-logo.svg)

**Enterprise-grade GitHub workspace with dark neon aesthetics and mobile-first design**

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Active-00d4aa?style=for-the-badge&logo=github)](https://github.com/tiaastor)
[![Mobile Optimized](https://img.shields.io/badge/Mobile-Optimized-ff6b9d?style=for-the-badge)](/)
[![Dark Theme](https://img.shields.io/badge/Theme-Dark%20Neon-00d4aa?style=for-the-badge)](/)

</div>

## 🚀 Overview

This workspace contains enterprise-grade tools, templates, and automation scripts for managing GitHub repositories with a focus on:

- 🌙 **Dark neon theme** with cyan/magenta gradients
- 📱 **Mobile-first optimization**
- 🏢 **Enterprise-grade documentation**
- ⚡ **Automated workflows**
- 💰 **SaaS monetization features**

## 📁 Directory Structure

```
tiation-github/
├── 📁 automation/           # Automation scripts and tools
├── 📁 templates/           # Reusable templates
├── 📁 documentation/       # Project documentation
├── 📁 assets/             # Static assets and branding
├── 📁 infrastructure/     # Infrastructure and deployment
├── 📁 tools/              # Development tools
└── 📁 archive/            # Archived files
```

## 🛠️ Quick Start

### Automation Scripts
```bash
# Run Python automation
./automation/python/enhance_all_docs.py

# Execute shell scripts
./automation/shell/setup_github_pages.sh
```

### Templates
- **Configuration**: `templates/config/`
- **Documentation**: `templates/documentation/`
- **Web Templates**: `templates/web/`

### Documentation
- **Guides**: Step-by-step instructions
- **Reports**: Status and analysis reports  
- **Architecture**: System design documentation

## 🎨 Theme & Design

All projects follow a consistent **dark neon theme** with:
- Primary: Cyan (#00d4aa)
- Secondary: Magenta (#ff6b9d)
- Background: Dark (#0a0a0a)
- Mobile-first responsive design

## 🔗 Key Features

- ✅ Enterprise-grade repository structure
- ✅ Mobile-optimized GitHub Pages
- ✅ SaaS monetization with Stripe/Supabase
- ✅ Automated documentation generation
- ✅ Interactive demos and architecture diagrams
- ✅ CI/CD workflows

## 📊 Project Status

Visit the [documentation/reports/](documentation/reports/) directory for detailed status reports and metrics.

## 🤝 Contributing

This workspace follows enterprise standards with comprehensive documentation, mobile optimization, and dark neon theming.

---

<div align="center">
<strong>Built with 💜 for enterprise-grade GitHub workflows</strong>
</div>
EOF

echo -e "${GREEN}✅ Enterprise README created${NC}"

# Update file permissions
echo -e "${YELLOW}🔒 Setting permissions...${NC}"
find automation/shell -name "*.sh" -exec chmod +x {} \;
find automation/python -name "*.py" -exec chmod +x {} \;

# Create index files for each directory
echo -e "${MAGENTA}📋 Creating directory indexes...${NC}"

# Automation index
cat > "automation/README.md" << 'EOF'
# 🤖 Automation Scripts

Enterprise automation tools for GitHub repository management.

## 🐍 Python Scripts
- Comprehensive documentation enhancement
- Repository analysis and reporting
- Branding and theme application

## ⚡ Shell Scripts  
- GitHub Pages setup automation
- Repository initialization
- Deployment and publishing

## 🔄 Workflows
- GitHub Actions templates
- CI/CD pipeline configurations
EOF

# Templates index
cat > "templates/README.md" << 'EOF'
# 📋 Templates

Reusable templates for consistent project structure.

## ⚙️ Configuration
- Pre-commit hooks
- Environment files
- Linting configurations

## 📚 Documentation
- README templates
- API documentation
- Enterprise standards

## 🌐 Web
- Sales page templates
- GitHub Pages themes
- Mobile-responsive designs
EOF

# Documentation index  
cat > "documentation/README.md" << 'EOF'
# 📚 Documentation

Comprehensive project documentation following enterprise standards.

## 📖 Guides
Step-by-step instructions and how-to guides

## 📊 Reports
Status reports, analysis, and metrics

## 🏗️ Architecture
System design, diagrams, and technical documentation

## 🔌 API
API documentation and references
EOF

echo -e "${GREEN}✅ File organization completed successfully!${NC}"
echo -e "${CYAN}📁 New enterprise structure is ready${NC}"
echo -e "${MAGENTA}🌟 All files organized with dark neon theme principles${NC}"

# Summary
echo -e "\n${YELLOW}📋 ORGANIZATION SUMMARY:${NC}"
echo -e "${CYAN}• Templates: $(find templates -type f | wc -l) files${NC}"
echo -e "${CYAN}• Automation: $(find automation -type f | wc -l) files${NC}"
echo -e "${CYAN}• Documentation: $(find documentation -type f | wc -l) files${NC}"
echo -e "${CYAN}• Assets: $(find assets -type f | wc -l) files${NC}"
echo -e "${CYAN}• Infrastructure: $(find infrastructure -type f | wc -l) files${NC}"

echo -e "\n${GREEN}🎉 Enterprise-grade organization complete!${NC}"
echo -e "${MAGENTA}Ready for mobile-first, dark neon themed development${NC}"
