#!/bin/bash

# 🌟 Tiation Enterprise Branding Automation Script
# Applies consistent branding across all repositories

set -e

# Ensure we're using bash 4+ for associative arrays
if [ ${BASH_VERSION%%.*} -lt 4 ]; then
    echo "Error: This script requires bash 4.0 or higher for associative arrays."
    exit 1
fi

# Colors for output
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Enterprise branding configuration
ENTERPRISE_EMAIL="tiatheone@protonmail.com"
GITHUB_USERNAME="tiaastor"
GITHUB_ORG="tiaastor"

# Repository configurations
declare -A REPO_CONFIGS=(
    ["tiation-terminal-workflows"]="Custom terminal automation workflows with enterprise productivity scripts"
    ["tiation-docker-debian"]="Enterprise Docker containers for Debian-based systems with professional deployment guides"
    ["tiation-ai-platform"]="Comprehensive AI platform with enterprise features and dark neon theme"
    ["tiation-ai-agents"]="AI agent frameworks and implementations for enterprise automation"
    ["tiation-cms"]="Enterprise content management system with dark neon theme"
    ["tiation-go-sdk"]="Go SDK for Tiation services with enterprise-grade features"
    ["tiation-parrot-security-guide-au"]="Security guide for Australian context with professional documentation"
    ["tiation-automation-workspace"]="Business process automation tools with enterprise workflows"
    ["tiation-rigger-workspace-docs"]="Comprehensive rigger workforce management documentation"
    ["DiceRollerSimulator"]="Advanced dice rolling simulator with dark neon theme"
    ["dice-roller-marketing-site"]="Marketing site for dice roller with professional design"
    ["liberation-system"]="Enterprise liberation system with comprehensive documentation"
    ["mark-photo-flare-site"]="Photo flare website with dark neon theme"
    ["tiation-chase-white-rabbit-ngo"]="NGO website with professional branding"
    ["tiation-economic-reform-proposal"]="Economic reform proposal with enterprise documentation"
    ["tiation-macos-networking-guide"]="macOS networking guide with professional standards"
    ["tough-talk-podcast-chaos"]="Podcast website with dark neon theme"
    ["ubuntu-dev-setup"]="Ubuntu development setup with enterprise standards"
)

# Technology stack configurations
declare -A TECH_STACKS=(
    ["tiation-terminal-workflows"]="- **Terminal**: Bash, Zsh, Fish\\n- **Automation**: Shell scripts, Warp workflows\\n- **Theme**: Dark neon with cyan/magenta gradients"
    ["tiation-docker-debian"]="- **Containers**: Docker, Docker Compose\\n- **OS**: Debian, Ubuntu\\n- **Orchestration**: Kubernetes, Docker Swarm"
    ["tiation-ai-platform"]="- **AI/ML**: TensorFlow, PyTorch, OpenAI\\n- **Backend**: Python, FastAPI\\n- **Database**: PostgreSQL, Redis"
    ["tiation-ai-agents"]="- **AI**: OpenAI, Anthropic, Local LLMs\\n- **Framework**: LangChain, CrewAI\\n- **Languages**: Python, TypeScript"
    ["tiation-cms"]="- **Frontend**: React, TypeScript, Tailwind CSS\\n- **Backend**: Node.js, Express\\n- **Database**: PostgreSQL, MongoDB"
    ["tiation-go-sdk"]="- **Language**: Go 1.19+\\n- **Framework**: Gin, Echo\\n- **Testing**: Testify, GoMock"
    ["default"]="- **Frontend**: Modern JavaScript frameworks\\n- **Backend**: Node.js, Python\\n- **Database**: PostgreSQL, MongoDB"
)

print_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                        ${MAGENTA}🌟 Tiation Enterprise Branding System 🌟${NC}                        ${CYAN}║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Applying consistent enterprise-grade branding with dark neon theme${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Contact: ${ENTERPRISE_EMAIL}${NC}                                              ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo -e "${CYAN}┌─────────────────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} $1 ${CYAN}│${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────────────────────────────────────────────────┘${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

apply_readme_template() {
    local repo_name=$1
    local repo_path=$2
    local description=${REPO_CONFIGS[$repo_name]:-"Enterprise-grade solution with dark neon theme"}
    local tech_stack=${TECH_STACKS[$repo_name]:-${TECH_STACKS["default"]}}
    
    print_info "Applying README template to $repo_name"
    
    # Create assets directory if it doesn't exist
    mkdir -p "$repo_path/assets"
    
    # Apply template with replacements
    sed -e "s/\[PROJECT_NAME\]/$repo_name/g" \
        -e "s/\[REPO_NAME\]/$repo_name/g" \
        -e "s/\[PROJECT_DESCRIPTION\]/$description/g" \
        -e "s/\[TECHNOLOGY_STACK_DETAILS\]/$tech_stack/g" \
        "$PWD/BRANDING_TEMPLATES/README_TEMPLATE.md" > "$repo_path/README.md"
    
    print_success "README.md updated for $repo_name"
}

apply_contributing_template() {
    local repo_name=$1
    local repo_path=$2
    
    print_info "Applying CONTRIBUTING template to $repo_name"
    
    # Apply template with replacements
    sed -e "s/\[PROJECT_NAME\]/$repo_name/g" \
        -e "s/\[REPO_NAME\]/$repo_name/g" \
        "$PWD/BRANDING_TEMPLATES/CONTRIBUTING_TEMPLATE.md" > "$repo_path/CONTRIBUTING.md"
    
    print_success "CONTRIBUTING.md updated for $repo_name"
}

create_github_templates() {
    local repo_path=$1
    local repo_name=$2
    
    print_info "Creating GitHub templates for $repo_name"
    
    # Create .github directory structure
    mkdir -p "$repo_path/.github/ISSUE_TEMPLATE"
    mkdir -p "$repo_path/.github/workflows"
    
    # Create pull request template
    cat > "$repo_path/.github/PULL_REQUEST_TEMPLATE.md" << EOF
# 🚀 Pull Request: $repo_name

## 📋 Description
<!-- Provide a clear and concise description of your changes -->

## 🎯 Type of Change
- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 🎨 Dark neon theme update
- [ ] 📚 Documentation update
- [ ] 🔒 Security improvement
- [ ] ⚡ Performance enhancement

## 🧪 Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Dark neon theme consistency verified

## 📸 Screenshots (if applicable)
<!-- Add screenshots showing the dark neon theme -->

## 🔗 Related Issues
<!-- Link to related issues -->
Closes #

## 📋 Checklist
- [ ] Code follows enterprise standards
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] Dark neon theme maintained
- [ ] Security reviewed
- [ ] Performance considered

## 📞 Contact
For questions: tiatheone@protonmail.com
EOF

    # Create issue templates
    cat > "$repo_path/.github/ISSUE_TEMPLATE/bug_report.md" << EOF
---
name: 🐛 Bug Report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

## 🐛 Bug Description
<!-- A clear and concise description of the bug -->

## 🔄 Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## 🎯 Expected Behavior
<!-- What you expected to happen -->

## 📸 Screenshots
<!-- Add screenshots if applicable -->

## 🖥️ Environment
- OS: [e.g., macOS, Linux, Windows]
- Browser: [e.g., Chrome, Firefox, Safari]
- Version: [e.g., 1.0.0]

## 📞 Contact
tiatheone@protonmail.com
EOF

    cat > "$repo_path/.github/ISSUE_TEMPLATE/feature_request.md" << EOF
---
name: ✨ Feature Request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## 🚀 Feature Description
<!-- A clear and concise description of what you want to happen -->

## 🎯 Problem Statement
<!-- What problem does this feature solve? -->

## 💡 Proposed Solution
<!-- Describe the solution you'd like -->

## 🎨 Dark Neon Theme Considerations
<!-- How should this feature integrate with our dark neon theme? -->

## 📋 Additional Context
<!-- Add any other context or screenshots about the feature request -->

## 📞 Contact
tiatheone@protonmail.com
EOF

    print_success "GitHub templates created for $repo_name"
}

create_assets_readme() {
    local repo_path=$1
    local repo_name=$2
    
    print_info "Creating assets README for $repo_name"
    
    cat > "$repo_path/assets/README.md" << EOF
# 🎨 Assets for $repo_name

This directory contains all visual assets for the $repo_name project, following our enterprise-grade dark neon theme standards.

## 🌟 Dark Neon Theme Specifications

### Color Palette
- **Primary Cyan**: \`#00D9FF\`
- **Primary Magenta**: \`#FF0080\`
- **Neon Green**: \`#00FF88\`
- **Background Dark**: \`#0D1117\`
- **Accent Yellow**: \`#FFE500\`

### Asset Guidelines
- All screenshots must use the dark neon theme
- Maintain consistent branding across all assets
- Use high-quality images (minimum 1920x1080 for screenshots)
- Include gradient effects with cyan/magenta accents

## 📁 Asset Structure

### Required Assets
- \`hero-banner.png\` - Main banner image
- \`overview-demo.png\` - Project overview screenshot
- \`feature-core.png\` - Core features screenshot
- \`feature-theme.png\` - Dark neon theme showcase
- \`feature-security.png\` - Security features
- \`feature-responsive.png\` - Responsive design
- \`demo-preview.png\` - Live demo preview
- \`architecture-diagram.png\` - System architecture
- \`desktop-interface.png\` - Desktop interface
- \`mobile-interface.png\` - Mobile interface
- \`dark-neon-theme.png\` - Theme showcase
- \`tech-stack.png\` - Technology stack
- \`performance-metrics.png\` - Performance metrics
- \`configuration-setup.png\` - Configuration setup
- \`documentation-preview.png\` - Documentation preview
- \`contribution-workflow.png\` - Contribution workflow
- \`testing-dashboard.png\` - Testing dashboard
- \`deployment-pipeline.png\` - Deployment pipeline
- \`roadmap.png\` - Project roadmap
- \`support-channels.png\` - Support channels
- \`acknowledgments.png\` - Acknowledgments
- \`footer-banner.png\` - Footer banner

### Optional Assets
- \`contributing-banner.png\` - Contributing banner
- \`contributing-footer.png\` - Contributing footer
- \`development-workflow.png\` - Development workflow

## 🎯 Asset Creation Guidelines

1. **Consistency**: Use the same design system across all assets
2. **Quality**: High-resolution images with sharp details
3. **Theme**: Always use dark neon theme with gradient accents
4. **Branding**: Include Tiation branding elements
5. **Professional**: Enterprise-grade visual standards

## 📞 Asset Support

For asset creation or updates:
- **Email**: tiatheone@protonmail.com
- **Repository**: https://github.com/tiaastor/$repo_name

---

**Built with ❤️ and enterprise-grade standards by [Tiation](https://github.com/tiaastor)**
EOF

    print_success "Assets README created for $repo_name"
}

process_repository() {
    local repo_name=$1
    local repo_path="/Users/tiaastor/tiation-github/$repo_name"
    
    print_section "Processing Repository: $repo_name"
    
    if [ ! -d "$repo_path" ]; then
        print_warning "Repository path not found: $repo_path"
        return 1
    fi
    
    # Apply templates
    apply_readme_template "$repo_name" "$repo_path"
    apply_contributing_template "$repo_name" "$repo_path"
    create_github_templates "$repo_path" "$repo_name"
    create_assets_readme "$repo_path" "$repo_name"
    
    print_success "Completed processing $repo_name"
    echo ""
}

main() {
    print_header
    
    # Check if we're in the right directory
    if [ ! -d "BRANDING_TEMPLATES" ]; then
        print_error "BRANDING_TEMPLATES directory not found. Please run from the tiation-github directory."
        exit 1
    fi
    
    print_section "🚀 Starting Enterprise Branding Application"
    
    # Process each repository
    for repo_name in "${!REPO_CONFIGS[@]}"; do
        process_repository "$repo_name"
    done
    
    print_section "✅ Branding Application Complete"
    
    echo -e "${GREEN}🎉 All repositories have been updated with enterprise-grade branding!${NC}"
    echo ""
    echo -e "${CYAN}📋 Summary:${NC}"
    echo -e "${CYAN}• Dark neon theme with cyan/magenta gradients${NC}"
    echo -e "${CYAN}• Enterprise-grade documentation standards${NC}"
    echo -e "${CYAN}• Consistent branding across all repositories${NC}"
    echo -e "${CYAN}• Professional contact information: ${ENTERPRISE_EMAIL}${NC}"
    echo -e "${CYAN}• GitHub Pages links for live demos${NC}"
    echo ""
    echo -e "${MAGENTA}🚀 Next Steps:${NC}"
    echo -e "${MAGENTA}1. Review and customize individual repository descriptions${NC}"
    echo -e "${MAGENTA}2. Add screenshots and assets to each repository${NC}"
    echo -e "${MAGENTA}3. Set up GitHub Pages for live demos${NC}"
    echo -e "${MAGENTA}4. Create and populate asset directories${NC}"
    echo -e "${MAGENTA}5. Test all links and functionality${NC}"
    echo ""
    echo -e "${GREEN}Built with ❤️ and enterprise-grade standards by Tiation${NC}"
}

# Run the main function
main "$@"
