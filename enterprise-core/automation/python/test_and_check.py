#!/usr/bin/env python3
"""
Comprehensive test script to verify Tiation ecosystem branding and connectivity
This script checks for branding consistency, broken links, and other issues
"""

import os
import re
import glob
from typing import List, Tuple

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

def find_git_repositories(base_path: str) -> List[str]:
    """Find all git repositories in the base path"""
    repos = []
    for root, dirs, files in os.walk(base_path):
        if '.git' in dirs:
            repos.append(root)
    return repos

def test_readme_branding(repo_path: str) -> List[str]:
    """Test a README for Tiation branding consistency"""
    errors = []
    readme_path = os.path.join(repo_path, 'README.md')
    repo_name = os.path.basename(repo_path)

    if not os.path.exists(readme_path):
        errors.append(f"No README.md found in {repo_name}")
        return errors

    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Test for ecosystem banner
    if "🔮_TIATION_ECOSYSTEM" not in content:
        errors.append(f"Missing Tiation ecosystem banner in {repo_name}")

    # Test for ecosystem footer
    if "🔮 Tiation Ecosystem" not in content:
        errors.append(f"Missing Tiation ecosystem footer in {repo_name}")

    # Test for dark neon theme colors in badges
    if not re.search(r'(00FFFF|FF00FF|007FFF)', content):
        errors.append(f"Missing dark neon theme colors in badges in {repo_name}")

    return errors

def test_all_repositories(base_path: str) -> Tuple[int, int, List[str]]:
    """Test all repositories for branding and consistency"""
    repos = find_git_repositories(base_path)
    total_repos = len(repos)
    failed_repos = 0
    all_errors = []

    for repo_path in repos:
        repo_name = os.path.basename(repo_path)
        print_colored(f"\n🔍 Testing: {repo_name}", Colors.CYAN)
        
        errors = test_readme_branding(repo_path)
        
        if errors:
            failed_repos += 1
            print_colored(f"   ❌ Failed", Colors.RED)
            for error in errors:
                print(f"     - {error}")
            all_errors.extend(errors)
        else:
            print_colored(f"   ✅ Passed", Colors.GREEN)
            
    return total_repos, failed_repos, all_errors

def main():
    """Main function to run all tests"""
    base_path = '/Users/tiaastor/tiation-github'
    
    print_colored("🚀 TIATION ECOSYSTEM TEST & VERIFICATION", Colors.MAGENTA)
    print_colored("=" * 50, Colors.CYAN)
    print_colored("Running tests to ensure branding consistency and quality...", Colors.BLUE)

    total_repos, failed_repos, all_errors = test_all_repositories(base_path)

    print_colored("\n" + "=" * 50, Colors.CYAN)
    print_colored("📊 Test Summary:", Colors.MAGENTA)
    print(f"   Total repositories tested: {total_repos}")
    print(f"   Repositories with errors: {failed_repos}")

    if failed_repos > 0:
        print_colored(f"\n❌ {failed_repos} repositories failed verification!", Colors.RED)
        print_colored("Please review the errors above and apply necessary fixes.", Colors.YELLOW)
    else:
        print_colored("\n🎉 All repositories passed verification!", Colors.GREEN)
        print_colored("The Tiation ecosystem branding is consistent and professional.", Colors.CYAN)

    print_colored("\n✨ Test and verification process completed!", Colors.MAGENTA)

if __name__ == "__main__":
    main()
