#!/usr/bin/env python3
"""
Quick fix script to address missing branding elements
"""

import os
import re

# Color codes for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    CYAN = '\033[0;36m'
    MAGENTA = '\033[0;35m'
    NC = '\033[0m'

def print_colored(text: str, color: str = Colors.NC) -> None:
    """Print text with color"""
    print(f"{color}{text}{Colors.NC}")

def fix_readme_branding(repo_path: str) -> bool:
    """Fix missing branding in README"""
    readme_path = os.path.join(repo_path, 'README.md')
    repo_name = os.path.basename(repo_path)
    
    if not os.path.exists(readme_path):
        return False
    
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if already has proper branding
    if "🔮_TIATION_ECOSYSTEM" in content and "🔮 Tiation Ecosystem" in content:
        return False
    
    # Add ecosystem footer if missing
    ecosystem_footer = """
---

## 🔮 Tiation Ecosystem

This repository is part of the Tiation ecosystem. Explore related projects:

- [🌟 TiaAstor](https://github.com/TiaAstor/TiaAstor) - Personal brand and story
- [🐰 ChaseWhiteRabbit NGO](https://github.com/tiation/tiation-chase-white-rabbit-ngo) - Social impact initiatives
- [🏗️ Infrastructure](https://github.com/tiation/tiation-rigger-infrastructure) - Enterprise infrastructure
- [🤖 AI Agents](https://github.com/tiation/tiation-ai-agents) - Intelligent automation
- [📝 CMS](https://github.com/tiation/tiation-cms) - Content management system
- [⚡ Terminal Workflows](https://github.com/tiation/tiation-terminal-workflows) - Developer tools

---
*Built with 💜 by the Tiation team*"""
    
    # Add footer if missing
    if "🔮 Tiation Ecosystem" not in content:
        content += ecosystem_footer
    
    # Write back to file
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    return True

def main():
    """Main function to fix branding issues"""
    base_path = '/Users/tiaastor/tiation-github'
    
    # List of repositories that need fixing based on test results
    repos_to_fix = [
        'tiation-ai-agents',
        'tiation-terminal-workflows', 
        'TiaAstor',
        'tiation-chase-white-rabbit-ngo',
        'tiation-rigger-infrastructure'
    ]
    
    print_colored("🔧 FIXING BRANDING ISSUES", Colors.MAGENTA)
    print_colored("=" * 40, Colors.CYAN)
    
    fixed_count = 0
    
    for repo_name in repos_to_fix:
        repo_path = os.path.join(base_path, repo_name)
        
        if os.path.exists(repo_path):
            print_colored(f"\n🔧 Fixing: {repo_name}", Colors.CYAN)
            
            if fix_readme_branding(repo_path):
                fixed_count += 1
                print_colored(f"   ✅ Fixed branding", Colors.GREEN)
            else:
                print_colored(f"   ℹ Already up to date", Colors.BLUE)
        else:
            print_colored(f"\n⚠ Repository not found: {repo_name}", Colors.YELLOW)
    
    print_colored(f"\n📊 Fixed {fixed_count} repositories", Colors.GREEN)
    print_colored("✨ Branding fix completed!", Colors.MAGENTA)

if __name__ == "__main__":
    main()
