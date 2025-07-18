#!/usr/bin/env python3
"""
Advanced coherence check script for Tiation ecosystem
Verifies consistency, cross-references, and narrative flow between repositories
"""

import os
import re
import json
from typing import Dict, List, Tuple, Set
from urllib.parse import urlparse

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
    print_colored(f"\n{'='*60}", Colors.CYAN)
    print_colored(f"🔍 {title.upper()}", Colors.MAGENTA)
    print_colored(f"{'='*60}", Colors.CYAN)

class RepositoryAnalyzer:
    def __init__(self, base_path: str):
        self.base_path = base_path
        self.repos = self._find_repositories()
        self.pinned_repos = [
            'TiaAstor',
            'tiation-chase-white-rabbit-ngo',
            'tiation-rigger-infrastructure', 
            'tiation-ai-agents',
            'tiation-cms',
            'tiation-terminal-workflows'
        ]
        
    def _find_repositories(self) -> List[str]:
        """Find all git repositories"""
        repos = []
        for root, dirs, files in os.walk(self.base_path):
            if '.git' in dirs:
                repos.append(root)
        return repos
    
    def _get_readme_content(self, repo_path: str) -> str:
        """Get README content for a repository"""
        readme_path = os.path.join(repo_path, 'README.md')
        if os.path.exists(readme_path):
            with open(readme_path, 'r', encoding='utf-8') as f:
                return f.read()
        return ""
    
    def check_branding_consistency(self) -> Tuple[int, int, List[str]]:
        """Check branding consistency across repositories"""
        print_section("BRANDING CONSISTENCY CHECK")
        
        passed = 0
        failed = 0
        issues = []
        
        expected_elements = {
            'ecosystem_banner': '🔮_TIATION_ECOSYSTEM',
            'ecosystem_footer': '🔮 Tiation Ecosystem',
            'dark_theme_colors': r'(00FFFF|FF00FF|007FFF)',
            'professional_badges': r'!\[.*\]\(https://img\.shields\.io/badge/',
        }
        
        for repo_path in self.repos:
            repo_name = os.path.basename(repo_path)
            content = self._get_readme_content(repo_path)
            
            if not content:
                continue
                
            repo_issues = []
            
            # Check each branding element
            for element, pattern in expected_elements.items():
                if element in ['ecosystem_banner', 'ecosystem_footer']:
                    if pattern not in content:
                        repo_issues.append(f"Missing {element}")
                else:
                    if not re.search(pattern, content):
                        repo_issues.append(f"Missing {element}")
            
            if repo_issues:
                failed += 1
                issues.extend([f"{repo_name}: {issue}" for issue in repo_issues])
                print_colored(f"❌ {repo_name}: {', '.join(repo_issues)}", Colors.RED)
            else:
                passed += 1
                print_colored(f"✅ {repo_name}: All branding elements present", Colors.GREEN)
        
        print_colored(f"\n📊 Branding Summary: {passed} passed, {failed} failed", Colors.WHITE)
        return passed, failed, issues
    
    def check_cross_references(self) -> Dict[str, List[str]]:
        """Check cross-references between repositories"""
        print_section("CROSS-REFERENCE VERIFICATION")
        
        cross_refs = {}
        missing_refs = []
        
        for repo_path in self.repos:
            repo_name = os.path.basename(repo_path)
            content = self._get_readme_content(repo_path)
            
            if not content:
                continue
            
            # Count references to pinned repositories
            refs_found = []
            for pinned_repo in self.pinned_repos:
                if pinned_repo in content:
                    refs_found.append(pinned_repo)
            
            cross_refs[repo_name] = refs_found
            
            # Check if ecosystem footer is present
            if '🔮 Tiation Ecosystem' in content:
                expected_refs = 6  # All pinned repos should be linked
                if len(refs_found) < expected_refs:
                    missing_count = expected_refs - len(refs_found)
                    missing_refs.append(f"{repo_name}: Missing {missing_count} cross-references")
                    print_colored(f"⚠️  {repo_name}: {len(refs_found)}/{expected_refs} cross-references", Colors.YELLOW)
                else:
                    print_colored(f"✅ {repo_name}: All {len(refs_found)} cross-references present", Colors.GREEN)
            else:
                print_colored(f"❌ {repo_name}: No ecosystem footer found", Colors.RED)
        
        if missing_refs:
            print_colored(f"\n⚠️  Cross-reference issues found:", Colors.YELLOW)
            for issue in missing_refs:
                print_colored(f"   - {issue}", Colors.YELLOW)
        else:
            print_colored(f"\n✅ All cross-references are properly maintained", Colors.GREEN)
        
        return cross_refs
    
    def check_narrative_coherence(self) -> Dict[str, str]:
        """Check narrative coherence across pinned repositories"""
        print_section("NARRATIVE COHERENCE CHECK")
        
        narratives = {}
        coherence_score = 0
        
        expected_narratives = {
            'TiaAstor': ['criminology', 'psychology', 'technology', 'personal', 'story'],
            'tiation-chase-white-rabbit-ngo': ['grief', 'systemic', 'change', 'ngo', 'social'],
            'tiation-rigger-infrastructure': ['infrastructure', 'enterprise', 'terraform', 'kubernetes'],
            'tiation-ai-agents': ['ai', 'automation', 'agents', 'mobile', 'react'],
            'tiation-cms': ['cms', 'content', 'management', 'enterprise', 'multi'],
            'tiation-terminal-workflows': ['terminal', 'workflow', 'automation', 'developer', 'warp']
        }
        
        for repo_name in self.pinned_repos:
            repo_path = os.path.join(self.base_path, repo_name)
            content = self._get_readme_content(repo_path).lower()
            
            if not content:
                print_colored(f"❌ {repo_name}: No README found", Colors.RED)
                continue
            
            # Check for expected narrative elements
            expected_words = expected_narratives.get(repo_name, [])
            found_words = [word for word in expected_words if word in content]
            
            narratives[repo_name] = found_words
            score = len(found_words) / len(expected_words) * 100
            
            if score >= 80:
                coherence_score += 1
                print_colored(f"✅ {repo_name}: Strong narrative coherence ({score:.1f}%)", Colors.GREEN)
            elif score >= 60:
                print_colored(f"⚠️  {repo_name}: Good narrative coherence ({score:.1f}%)", Colors.YELLOW)
            else:
                print_colored(f"❌ {repo_name}: Weak narrative coherence ({score:.1f}%)", Colors.RED)
        
        overall_coherence = (coherence_score / len(self.pinned_repos)) * 100
        print_colored(f"\n📊 Overall Narrative Coherence: {overall_coherence:.1f}%", Colors.WHITE)
        
        return narratives
    
    def check_technical_consistency(self) -> Dict[str, List[str]]:
        """Check technical consistency across repositories"""
        print_section("TECHNICAL CONSISTENCY CHECK")
        
        tech_patterns = {
            'badges': r'!\[.*\]\(https://img\.shields\.io/badge/',
            'license': r'license|License|LICENSE',
            'contributing': r'contribut|Contribut|CONTRIBUT',
            'documentation': r'docs?/|documentation|Documentation',
            'github_actions': r'\.github/workflows',
        }
        
        tech_consistency = {}
        
        for repo_path in self.repos:
            repo_name = os.path.basename(repo_path)
            content = self._get_readme_content(repo_path)
            
            if not content:
                continue
            
            found_patterns = []
            
            for pattern_name, pattern in tech_patterns.items():
                if re.search(pattern, content):
                    found_patterns.append(pattern_name)
            
            tech_consistency[repo_name] = found_patterns
            
            # Check for specific technical elements
            if len(found_patterns) >= 3:
                print_colored(f"✅ {repo_name}: Good technical consistency ({len(found_patterns)}/5)", Colors.GREEN)
            elif len(found_patterns) >= 2:
                print_colored(f"⚠️  {repo_name}: Moderate technical consistency ({len(found_patterns)}/5)", Colors.YELLOW)
            else:
                print_colored(f"❌ {repo_name}: Low technical consistency ({len(found_patterns)}/5)", Colors.RED)
        
        return tech_consistency
    
    def check_ecosystem_links(self) -> Dict[str, bool]:
        """Check if ecosystem links are working and consistent"""
        print_section("ECOSYSTEM LINKS VERIFICATION")
        
        expected_links = {
            'TiaAstor': 'https://github.com/TiaAstor/TiaAstor',
            'ChaseWhiteRabbit NGO': 'https://github.com/tiation/tiation-chase-white-rabbit-ngo',
            'Infrastructure': 'https://github.com/tiation/tiation-rigger-infrastructure',
            'AI Agents': 'https://github.com/tiation/tiation-ai-agents',
            'CMS': 'https://github.com/tiation/tiation-cms',
            'Terminal Workflows': 'https://github.com/tiation/tiation-terminal-workflows'
        }
        
        link_status = {}
        
        for repo_path in self.repos:
            repo_name = os.path.basename(repo_path)
            content = self._get_readme_content(repo_path)
            
            if not content:
                continue
            
            # Check if ecosystem footer is present
            if '🔮 Tiation Ecosystem' in content:
                links_found = 0
                for link_name, link_url in expected_links.items():
                    if link_url in content:
                        links_found += 1
                
                link_status[repo_name] = links_found == len(expected_links)
                
                if links_found == len(expected_links):
                    print_colored(f"✅ {repo_name}: All ecosystem links present", Colors.GREEN)
                else:
                    print_colored(f"⚠️  {repo_name}: {links_found}/{len(expected_links)} ecosystem links", Colors.YELLOW)
            else:
                link_status[repo_name] = False
                print_colored(f"❌ {repo_name}: No ecosystem footer found", Colors.RED)
        
        return link_status
    
    def generate_coherence_report(self) -> Dict:
        """Generate comprehensive coherence report"""
        print_section("COMPREHENSIVE COHERENCE REPORT")
        
        # Run all checks
        branding_passed, branding_failed, branding_issues = self.check_branding_consistency()
        cross_refs = self.check_cross_references()
        narratives = self.check_narrative_coherence()
        tech_consistency = self.check_technical_consistency()
        link_status = self.check_ecosystem_links()
        
        # Calculate overall scores
        total_repos = len([r for r in self.repos if self._get_readme_content(r)])
        branding_score = (branding_passed / total_repos) * 100 if total_repos > 0 else 0
        
        # Generate report
        report = {
            'timestamp': '2025-07-18T16:39:29Z',
            'total_repositories': total_repos,
            'branding_score': branding_score,
            'branding_passed': branding_passed,
            'branding_failed': branding_failed,
            'pinned_repos_status': {repo: repo in narratives for repo in self.pinned_repos},
            'cross_references': cross_refs,
            'narrative_coherence': narratives,
            'technical_consistency': tech_consistency,
            'ecosystem_links': link_status,
            'issues': branding_issues
        }
        
        # Print summary
        print_colored(f"\n📊 FINAL COHERENCE SUMMARY", Colors.WHITE)
        print_colored(f"Total repositories analyzed: {total_repos}", Colors.CYAN)
        print_colored(f"Branding consistency: {branding_score:.1f}%", Colors.CYAN)
        print_colored(f"Pinned repositories: {len([r for r in self.pinned_repos if r in narratives])}/6 properly configured", Colors.CYAN)
        
        if branding_score >= 90:
            print_colored(f"🎉 EXCELLENT: Ecosystem coherence is outstanding!", Colors.GREEN)
        elif branding_score >= 80:
            print_colored(f"✅ GOOD: Ecosystem coherence is strong with minor issues", Colors.GREEN)
        elif branding_score >= 70:
            print_colored(f"⚠️  FAIR: Ecosystem coherence needs improvement", Colors.YELLOW)
        else:
            print_colored(f"❌ POOR: Ecosystem coherence requires significant work", Colors.RED)
        
        return report

def main():
    """Main function to run coherence checks"""
    base_path = '/Users/tiaastor/tiation-github'
    
    print_colored("🔍 TIATION ECOSYSTEM COHERENCE CHECK", Colors.MAGENTA)
    print_colored("=" * 60, Colors.CYAN)
    print_colored("Verifying consistency, cross-references, and narrative flow...", Colors.BLUE)
    
    analyzer = RepositoryAnalyzer(base_path)
    report = analyzer.generate_coherence_report()
    
    # Save report
    with open('coherence_report.json', 'w') as f:
        json.dump(report, f, indent=2)
    
    print_colored(f"\n📄 Detailed report saved to: coherence_report.json", Colors.CYAN)
    print_colored("🎯 Coherence check completed!", Colors.MAGENTA)

if __name__ == "__main__":
    main()
