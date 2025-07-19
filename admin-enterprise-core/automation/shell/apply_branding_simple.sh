#!/bin/bash

# 🌟 Simple Tiation Enterprise Branding Script
# Applies consistent branding to key repositories

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}🌟 Applying Tiation Enterprise Branding${NC}"
echo -e "${CYAN}Contact: tiatheone@protonmail.com${NC}"
echo ""

# List of main repositories to update
repositories=(
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

# Function to update repository footer
update_footer() {
    local repo_path=$1
    local repo_name=$2
    
    if [ -f "$repo_path/README.md" ]; then
        echo -e "${YELLOW}Updating footer for $repo_name${NC}"
        
        # Add footer section if it doesn't exist
        if ! grep -q "Support & Contact" "$repo_path/README.md"; then
            cat >> "$repo_path/README.md" << 'EOF'

---

## 📞 Support & Contact

- 📧 **Enterprise Support**: [tiatheone@protonmail.com](mailto:tiatheone@protonmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/tiaastor/REPO_NAME/issues)
- 📖 **Documentation**: [Wiki](https://github.com/tiaastor/REPO_NAME/wiki)
- 🔗 **GitHub**: [Repository](https://github.com/tiaastor/REPO_NAME)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Related Projects

- [Tiation Terminal Workflows](https://github.com/tiaastor/tiation-terminal-workflows)
- [Tiation Docker Debian](https://github.com/tiaastor/tiation-docker-debian)
- [Tiation AI Platform](https://github.com/tiaastor/tiation-ai-platform)
- [Tiation CMS](https://github.com/tiaastor/tiation-cms)

---

<div align="center">
  **⭐ Star this repository if you find it helpful! ⭐**
  
  <p><strong>Built with ❤️ and enterprise-grade standards by <a href="https://github.com/tiaastor">Tiation</a></strong></p>
</div>
EOF
            # Replace REPO_NAME with actual repository name
            sed -i '' "s/REPO_NAME/$repo_name/g" "$repo_path/README.md"
            echo -e "${GREEN}✓ Footer added to $repo_name${NC}"
        else
            echo -e "${YELLOW}Footer already exists for $repo_name${NC}"
        fi
    fi
}

# Function to create assets directory and README
create_assets_structure() {
    local repo_path=$1
    local repo_name=$2
    
    mkdir -p "$repo_path/assets"
    
    if [ ! -f "$repo_path/assets/README.md" ]; then
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

## 📞 Asset Support

For asset creation or updates:
- **Email**: tiatheone@protonmail.com
- **Repository**: https://github.com/tiaastor/$repo_name

---

**Built with ❤️ and enterprise-grade standards by [Tiation](https://github.com/tiaastor)**
EOF
        echo -e "${GREEN}✓ Assets README created for $repo_name${NC}"
    fi
}

# Process each repository
for repo in "${repositories[@]}"; do
    repo_path="/Users/tiaastor/tiation-github/$repo"
    
    if [ -d "$repo_path" ]; then
        echo -e "${CYAN}Processing $repo...${NC}"
        update_footer "$repo_path" "$repo"
        create_assets_structure "$repo_path" "$repo"
    else
        echo -e "${YELLOW}Repository not found: $repo${NC}"
    fi
done

echo ""
echo -e "${GREEN}🎉 Branding application complete!${NC}"
echo -e "${GREEN}All repositories now have consistent enterprise-grade branding${NC}"
echo -e "${GREEN}Contact: tiatheone@protonmail.com${NC}"
