#!/usr/bin/env python3
"""
Targeted script to fix all remaining incoherence issues
This will bring the ecosystem to 100% coherence
"""

import os
import re
import shutil

# Color codes for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    CYAN = '\033[0;36m'
    MAGENTA = '\033[0;35m'
    WHITE = '\033[1;37m'
    NC = '\033[0m'

def print_colored(text: str, color: str = Colors.NC) -> None:
    """Print text with color"""
    print(f"{color}{text}{Colors.NC}")

def print_section(title: str) -> None:
    """Print a section header"""
    print_colored(f"\n{'='*50}", Colors.CYAN)
    print_colored(f"🔧 {title.upper()}", Colors.MAGENTA)
    print_colored(f"{'='*50}", Colors.CYAN)

# Repository-specific configurations for the problematic repos
REPO_CONFIGS = {
    'tiation-automation-workspace': {
        'tagline': 'Automated • Efficient • Enterprise-Ready',
        'description': 'Enterprise automation workspace for streamlined development',
        'primary_color': '00FFFF',
        'badges': [
            ('🤖_Automation', 'Workflow_Management', '00FFFF'),
            ('🏢_Enterprise', 'Ready', 'FF00FF'),
            ('📊_Monitoring', 'Built_In', '007FFF'),
            ('⚡_Performance', 'Optimized', '00FFFF')
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
    },
    'mark-photo-flare-site': {
        'tagline': 'Professional • Creative • Modern',
        'description': 'Professional photography portfolio with creative flair',
        'primary_color': 'FF00FF',
        'badges': [
            ('📸_Photography', 'Portfolio', 'FF00FF'),
            ('🎨_Creative', 'Design', '00FFFF'),
            ('🌐_Website', 'Modern', '007FFF'),
            ('📱_Responsive', 'Mobile_Ready', '00FFFF')
        ]
    },
    'tiation-react-template': {
        'tagline': 'Modern • Scalable • Enterprise-Ready',
        'description': 'Enterprise React template with dark neon theme',
        'primary_color': '007FFF',
        'badges': [
            ('⚛️_React', 'TypeScript', '007FFF'),
            ('🎨_Template', 'Dark_Neon', 'FF00FF'),
            ('🏢_Enterprise', 'Ready', '00FFFF'),
            ('📱_Responsive', 'Modern', '007FFF')
        ]
    },
    'tiation-docker-debian': {
        'tagline': 'Containerized • Secure • Production-Ready',
        'description': 'Docker containerization for Debian-based systems',
        'primary_color': '007FFF',
        'badges': [
            ('🐳_Docker', 'Containerization', '007FFF'),
            ('🐧_Debian', 'Linux', '00FFFF'),
            ('🔒_Security', 'Hardened', 'FF00FF'),
            ('🏭_Production', 'Ready', '007FFF')
        ]
    },
    'shattered-realms-nexus': {
        'tagline': 'Immersive • Interactive • Community-Driven',
        'description': 'Gaming platform for community interaction and engagement',
        'primary_color': 'FF00FF',
        'badges': [
            ('🎮_Gaming', 'Platform', 'FF00FF'),
            ('🌐_Community', 'Interactive', '00FFFF'),
            ('⚡_Real_Time', 'Engagement', '007FFF'),
            ('🎨_Immersive', 'Experience', 'FF00FF')
        ]
    },
    'tiation-rigger-workspace-docs': {
        'tagline': 'Comprehensive • Professional • Well-Documented',
        'description': 'Professional documentation for Tiation Rigger workspace',
        'primary_color': '007FFF',
        'badges': [
            ('📚_Documentation', 'Complete', '007FFF'),
            ('🏗️_Workspace', 'Rigger_Platform', '00FFFF'),
            ('📋_Guides', 'Professional', 'FF00FF'),
            ('🔧_Technical', 'Reference', '007FFF')
        ]
    }
}

def create_ecosystem_banner(repo_name: str, config: dict) -> str:
    """Create the ecosystem banner for a repository"""
    clean_name = repo_name.replace('-', '_').replace('.', '_')
    return f"![Tiation Ecosystem](https://img.shields.io/badge/🔮_TIATION_ECOSYSTEM-{clean_name}-00FFFF?style=for-the-badge&labelColor=0A0A0A&color={config['primary_color']})"

def create_badges(repo_name: str, config: dict) -> list:
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

def fix_repository_branding(repo_path: str, repo_name: str) -> bool:
    """Fix complete branding for a repository"""
    readme_path = os.path.join(repo_path, 'README.md')
    
    if not os.path.exists(readme_path):
        print_colored(f"   ❌ No README.md found", Colors.RED)
        return False
    
    # Create backup
    backup_path = readme_path + '.backup'
    shutil.copy2(readme_path, backup_path)
    
    # Read current content
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Get repository configuration
    config = REPO_CONFIGS.get(repo_name, {
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
    
    # Extract title
    title_match = re.search(r'^# (.+)$', content, re.MULTILINE)
    title = title_match.group(1) if title_match else repo_name.replace('-', ' ').title()
    
    # Create new branded header
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
    
    # Remove existing title and any existing branding
    content_lines = content.split('\n')
    
    # Remove title line if it exists
    if content_lines and content_lines[0].startswith('# '):
        content_lines = content_lines[1:]
    
    # Remove existing ecosystem banner/branding if present
    filtered_lines = []
    skip_until_line = None
    
    for i, line in enumerate(content_lines):
        if '🔮_TIATION_ECOSYSTEM' in line:
            # Skip until we find the end of the branding section
            skip_until_line = None
            for j in range(i, len(content_lines)):
                if content_lines[j].strip() == '---' and j > i:
                    skip_until_line = j + 1
                    break
            if skip_until_line:
                continue
        elif skip_until_line and i < skip_until_line:
            continue
        else:
            skip_until_line = None
            filtered_lines.append(line)
    
    # Remove empty lines at the beginning
    while filtered_lines and filtered_lines[0].strip() == '':
        filtered_lines.pop(0)
    
    remaining_content = '\n'.join(filtered_lines)
    
    # Remove existing ecosystem footer if present
    if '🔮 Tiation Ecosystem' in remaining_content:
        footer_start = remaining_content.find('## 🔮 Tiation Ecosystem')
        if footer_start != -1:
            # Find the end of the footer (look for next ## or end of file)
            footer_end = len(remaining_content)
            next_section = remaining_content.find('\n## ', footer_start + 1)
            if next_section != -1:
                footer_end = next_section
            remaining_content = remaining_content[:footer_start].rstrip()
    
    # Create footer
    footer = f"\n\n---\n\n{create_ecosystem_footer()}"
    
    # Combine everything
    new_content = header + remaining_content + footer
    
    # Write updated README
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    return True

def main():
    """Main function to fix all incoherence issues"""
    base_path = '/Users/tiaastor/tiation-github'
    
    print_section("FIXING ALL ECOSYSTEM INCOHERENCE")
    print_colored("Targeting 7 repositories with branding gaps...", Colors.BLUE)
    
    # List of repositories that need fixing based on coherence check
    repos_to_fix = [
        'tiation-automation-workspace',
        'tiation-terminal-workflows',
        'mark-photo-flare-site',
        'tiation-react-template',
        'tiation-docker-debian',
        'shattered-realms-nexus',
        'tiation-rigger-workspace-docs'
    ]
    
    fixed_count = 0
    
    for repo_name in repos_to_fix:
        repo_path = os.path.join(base_path, repo_name)
        
        print_colored(f"\n🔧 Fixing: {repo_name}", Colors.CYAN)
        
        if os.path.exists(repo_path):
            if fix_repository_branding(repo_path, repo_name):
                fixed_count += 1
                print_colored(f"   ✅ Complete branding applied", Colors.GREEN)
            else:
                print_colored(f"   ❌ Failed to fix branding", Colors.RED)
        else:
            print_colored(f"   ⚠️ Repository not found", Colors.YELLOW)
    
    print_section("INCOHERENCE FIX COMPLETE")
    print_colored(f"Fixed {fixed_count}/{len(repos_to_fix)} repositories", Colors.WHITE)
    print_colored("🎉 Ecosystem should now achieve 100% coherence!", Colors.GREEN)

if __name__ == "__main__":
    main()
