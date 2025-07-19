#!/usr/bin/env python3
"""
Advanced script to apply unified dark neon branding to all Tiation repositories
This script intelligently updates README files while preserving existing content
"""

import os
import re
import glob
import shutil
from pathlib import Path
from typing import Dict, List, Optional, Tuple

# Color codes for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    CYAN = '\033[0;36m'
    MAGENTA = '\033[0;35m'
    NC = '\033[0m'  # No Color

def print_colored(text: str, color: str = Colors.NC) -> None:
    """Print text with color"""
    print(f"{color}{text}{Colors.NC}")

# Repository-specific branding configurations
REPO_CONFIGS = {
    'tiation-ai-agents': {
        'tagline': 'AI-Powered • Scalable • Cross-Platform',
        'description': 'Intelligent automation agents for enterprise workflows',
        'primary_color': 'FF00FF',
        'badges': [
            ('📱_Mobile_App', 'React_Native', '00FFFF'),
            ('🤖_AI_Engine', 'Machine_Learning', 'FF00FF'),
            ('🌐_Web_Demo', 'Live_Dashboard', '007FFF'),
            ('📚_Documentation', 'Complete', '00FFFF')
        ]
    },
    'tiation-chase-white-rabbit-ngo': {
        'tagline': 'Mission-Driven • Transparent • Transformative',
        'description': 'Transforming grief into systemic change through technology',
        'primary_color': '00FFFF',
        'badges': [
            ('🐰_NGO', 'Social_Impact', '00FFFF'),
            ('🎨_GriefToDesign', 'Methodology', 'FF00FF'),
            ('💰_Solution', '$19_Trillion', '007FFF'),
            ('🌍_Impact', 'Global', '00FFFF')
        ]
    },
    'tiation-rigger-infrastructure': {
        'tagline': 'Scalable • Secure • Enterprise-Grade',
        'description': 'Enterprise infrastructure automation with Terraform & Kubernetes',
        'primary_color': '007FFF',
        'badges': [
            ('🏗️_Infrastructure', 'Terraform', '007FFF'),
            ('☸️_Kubernetes', 'Orchestration', '00FFFF'),
            ('🔄_CI_CD', 'Automated', 'FF00FF'),
            ('🔒_Security', 'Enterprise', '007FFF')
        ]
    },
    'tiation-cms': {
        'tagline': 'Multi-Tenant • API-First • Enterprise',
        'description': 'Enterprise content management with revenue generation',
        'primary_color': 'FF00FF',
        'badges': [
            ('📝_CMS', 'Multi_Tenant', 'FF00FF'),
            ('🔌_API', 'RESTful', '00FFFF'),
            ('💼_Enterprise', 'Scalable', '007FFF'),
            ('📊_Analytics', 'Built_In', '00FFFF')
        ]
    },
    'tiation-terminal-workflows': {
        'tagline': 'Automated • Efficient • Developer-Focused',
        'description': 'Enterprise productivity tools for Warp terminal',
        'primary_color': '00FFFF',
        'badges': [
            ('⚡_Terminal', 'Warp_Workflows', '00FFFF'),
            ('🤖_Automation', 'Scripts', 'FF00FF'),
            ('🛠️_Tools', 'Developer', '007FFF'),
            ('🚀_Productivity', 'Enterprise', '00FFFF')
        ]
    }
}

def get_repo_config(repo_name: str) -> Dict:
    """Get configuration for a specific repository"""
    return REPO_CONFIGS.get(repo_name, {
        'tagline': 'Professional • Scalable • Mission-Driven',
        'description': 'Enterprise-grade solution in the Tiation ecosystem',
        'primary_color': '00FFFF',
        'badges': [
            ('🌐_Live_Demo', 'View_Project', '00FFFF'),
            ('📚_Documentation', 'Complete', '007FFF'),
            ('⚡_Status', 'Active_Development', 'FF00FF'),
            ('📄_License', 'MIT', '00FFFF')
        ]
    })

def create_ecosystem_banner(repo_name: str, config: Dict) -> str:
    """Create the ecosystem banner for a repository"""
    clean_name = repo_name.replace('-', '_').replace('.', '_')
    return f"![Tiation Ecosystem](https://img.shields.io/badge/🔮_TIATION_ECOSYSTEM-{clean_name}-00FFFF?style=for-the-badge&labelColor=0A0A0A&color={config['primary_color']})"

def create_badges(repo_name: str, config: Dict) -> List[str]:
    """Create badge links for a repository"""
    badges = []
    for badge_text, badge_desc, color in config['badges']:
        badge_url = f"https://img.shields.io/badge/{badge_text}-{badge_desc}-{color}?style=flat-square&labelColor=0A0A0A"
        badges.append(f"[![{badge_text}]({badge_url})](https://github.com/tiation/{repo_name})")
    return badges

def create_ecosystem_footer() -> str:
    """Create the ecosystem footer"""
    return """## 🔮 Tiation Ecosystem

This repository is part of the Tiation ecosystem. Explore related projects:

- [🌟 TiaAstor](https://github.com/TiaAstor/TiaAstor) - Personal brand and story
- [🐰 ChaseWhiteRabbit NGO](https://github.com/tiation/tiation-chase-white-rabbit-ngo) - Social impact initiatives
- [🏗️ Infrastructure](https://github.com/tiation/tiation-rigger-infrastructure) - Enterprise infrastructure
- [🤖 AI Agents](https://github.com/tiation/tiation-ai-agents) - Intelligent automation
- [📝 CMS](https://github.com/tiation/tiation-cms) - Content management system
- [⚡ Terminal Workflows](https://github.com/tiation/tiation-terminal-workflows) - Developer tools

---
*Built with 💜 by the Tiation team*"""

def extract_title_from_readme(content: str) -> str:
    """Extract the title from README content"""
    lines = content.split('\n')
    for line in lines:
        if line.strip().startswith('# '):
            return line.strip()[2:]  # Remove '# '
    return "Project"

def has_tiation_branding(content: str) -> bool:
    """Check if README already has Tiation branding"""
    return '🔮_TIATION_ECOSYSTEM' in content

def update_readme_with_branding(repo_path: str, repo_name: str) -> bool:
    """Update a repository's README with Tiation branding"""
    readme_path = os.path.join(repo_path, 'README.md')
    
    if not os.path.exists(readme_path):
        print_colored(f"   ⚠ No README.md found, skipping", Colors.YELLOW)
        return False
    
    # Read current README
    with open(readme_path, 'r', encoding='utf-8') as f:
        current_content = f.read()
    
    # Check if already branded
    if has_tiation_branding(current_content):
        print_colored(f"   ℹ Already has Tiation branding", Colors.BLUE)
        return False
    
    # Create backup
    backup_path = readme_path + '.backup'
    shutil.copy2(readme_path, backup_path)
    
    # Extract title and content
    title = extract_title_from_readme(current_content)
    
    # Get repository configuration
    config = get_repo_config(repo_name)
    
    # Create branded header
    banner = create_ecosystem_banner(repo_name, config)
    badges = create_badges(repo_name, config)
    
    header = f"""# {title}

<div align="center">

{banner}

**{config['description']}**

*{config['tagline']}*

{chr(10).join(badges)}

</div>

---
"""
    
    # Remove existing title from content
    content_lines = current_content.split('\n')
    if content_lines and content_lines[0].startswith('# '):
        content_lines = content_lines[1:]
    
    # Remove empty lines at the beginning
    while content_lines and content_lines[0].strip() == '':
        content_lines.pop(0)
    
    remaining_content = '\n'.join(content_lines)
    
    # Create footer
    footer = f"\n---\n\n{create_ecosystem_footer()}"
    
    # Combine everything
    new_content = header + remaining_content + footer
    
    # Write updated README
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print_colored(f"   ✓ README updated with Tiation branding", Colors.GREEN)
    return True

def find_git_repositories(base_path: str) -> List[str]:
    """Find all git repositories in the base path"""
    repos = []
    for root, dirs, files in os.walk(base_path):
        if '.git' in dirs:
            repos.append(root)
    return repos

def main():
    """Main function to apply branding to all repositories"""
    base_path = '/Users/tiaastor/tiation-github'
    
    print_colored("🔮 TIATION ECOSYSTEM BRANDING UPDATE", Colors.CYAN)
    print_colored("=" * 50, Colors.MAGENTA)
    print_colored("Applying unified dark neon branding to all repositories...", Colors.BLUE)
    
    # Find all repositories
    repos = find_git_repositories(base_path)
    
    total_repos = 0
    repos_updated = 0
    repos_skipped = 0
    
    for repo_path in repos:
        repo_name = os.path.basename(repo_path)
        
        print_colored(f"\n📁 Processing: {repo_name}", Colors.CYAN)
        print(f"   Path: {repo_path}")
        
        total_repos += 1
        
        if update_readme_with_branding(repo_path, repo_name):
            repos_updated += 1
        else:
            repos_skipped += 1
    
    print_colored("\n" + "=" * 50, Colors.MAGENTA)
    print_colored("📊 Branding Update Summary:", Colors.CYAN)
    print(f"   Total repositories processed: {total_repos}")
    print(f"   Repositories updated: {repos_updated}")
    print(f"   Repositories skipped: {repos_skipped}")
    
    if repos_updated > 0:
        print_colored(f"\n🎉 Successfully applied unified branding to {repos_updated} repositories!", Colors.GREEN)
    
    print_colored("\n✨ Tiation Ecosystem branding update completed!", Colors.CYAN)

if __name__ == "__main__":
    main()
