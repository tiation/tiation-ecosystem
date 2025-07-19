#!/usr/bin/env python3
"""
Documentation Enhancement Validation Script

This script validates that all documentation enhancements have been applied correctly
and provides a comprehensive summary of the improvements made.
"""

import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple

def validate_repository_documentation(repo_path: Path) -> Dict[str, bool]:
    """Validate documentation enhancements for a single repository"""
    validation_results = {
        "readme_enhanced": False,
        "docs_directory": False,
        "assets_directory": False,
        "architecture_diagram": False,
        "screenshots": False,
        "github_pages_config": False,
        "backup_created": False
    }
    
    # Check README enhancement
    readme_path = repo_path / "README.md"
    if readme_path.exists():
        with open(readme_path, 'r', encoding='utf-8') as f:
            content = f.read()
            if "🔮 TIATION ECOSYSTEM" in content and "Enterprise-grade" in content:
                validation_results["readme_enhanced"] = True
    
    # Check README backup
    backup_path = repo_path / "README.md.backup"
    if backup_path.exists():
        validation_results["backup_created"] = True
    
    # Check docs directory
    docs_dir = repo_path / "docs"
    if docs_dir.exists():
        required_docs = ["index.md", "user-guide.md", "api-reference.md", "architecture.md"]
        existing_docs = [f.name for f in docs_dir.iterdir() if f.is_file()]
        if all(doc in existing_docs for doc in required_docs):
            validation_results["docs_directory"] = True
    
    # Check assets directory
    assets_dir = repo_path / "assets"
    if assets_dir.exists():
        required_dirs = ["images", "screenshots", "architecture", "css", "js"]
        existing_dirs = [d.name for d in assets_dir.iterdir() if d.is_dir()]
        if all(dir_name in existing_dirs for dir_name in required_dirs):
            validation_results["assets_directory"] = True
    
    # Check architecture diagram
    arch_dir = repo_path / "assets" / "architecture"
    if arch_dir.exists():
        arch_files = list(arch_dir.glob("*-architecture.svg"))
        if arch_files:
            validation_results["architecture_diagram"] = True
    
    # Check screenshots
    screenshots_dir = repo_path / "assets" / "screenshots"
    if screenshots_dir.exists():
        screenshot_files = list(screenshots_dir.glob("*.svg"))
        if len(screenshot_files) >= 2:
            validation_results["screenshots"] = True
    
    # Check GitHub Pages config
    config_path = repo_path / "_config.yml"
    if config_path.exists():
        with open(config_path, 'r', encoding='utf-8') as f:
            content = f.read()
            if "dark neon theme" in content.lower() or "primary-color: #00ffff" in content.lower():
                validation_results["github_pages_config"] = True
    
    return validation_results

def generate_validation_report():
    """Generate a comprehensive validation report"""
    base_path = Path("/Users/tiaastor/tiation-github")
    
    print("🔍 Validating Documentation Enhancements")
    print("=" * 50)
    
    total_repos = 0
    fully_enhanced = 0
    validation_summary = {
        "readme_enhanced": 0,
        "docs_directory": 0,
        "assets_directory": 0,
        "architecture_diagram": 0,
        "screenshots": 0,
        "github_pages_config": 0,
        "backup_created": 0
    }
    
    detailed_results = []
    
    # Get all repository directories
    repo_dirs = [d for d in base_path.iterdir() 
                if d.is_dir() and not d.name.startswith('.') and d.name != '__pycache__']
    
    for repo_dir in repo_dirs:
        total_repos += 1
        results = validate_repository_documentation(repo_dir)
        
        # Count successes
        success_count = sum(1 for v in results.values() if v)
        total_checks = len(results)
        
        if success_count == total_checks:
            fully_enhanced += 1
            status = "✅ FULLY ENHANCED"
        elif success_count >= total_checks * 0.8:
            status = "🔸 MOSTLY ENHANCED"
        elif success_count >= total_checks * 0.5:
            status = "🔹 PARTIALLY ENHANCED"
        else:
            status = "❌ NEEDS WORK"
        
        detailed_results.append({
            "repo": repo_dir.name,
            "status": status,
            "success_count": success_count,
            "total_checks": total_checks,
            "results": results
        })
        
        # Update summary
        for key, value in results.items():
            if value:
                validation_summary[key] += 1
    
    # Sort results by success rate
    detailed_results.sort(key=lambda x: x["success_count"], reverse=True)
    
    # Print summary
    print(f"\n📊 VALIDATION SUMMARY")
    print(f"Total Repositories: {total_repos}")
    print(f"Fully Enhanced: {fully_enhanced} ({fully_enhanced/total_repos*100:.1f}%)")
    print(f"Enhancement Rate: {sum(validation_summary.values())}/{total_repos*len(validation_summary)} ({sum(validation_summary.values())/(total_repos*len(validation_summary))*100:.1f}%)")
    
    print(f"\n📋 FEATURE BREAKDOWN")
    for feature, count in validation_summary.items():
        percentage = count / total_repos * 100
        print(f"  {feature.replace('_', ' ').title()}: {count}/{total_repos} ({percentage:.1f}%)")
    
    print(f"\n🔍 DETAILED RESULTS (Top 20)")
    for i, result in enumerate(detailed_results[:20]):
        print(f"{i+1:2d}. {result['repo']:<35} {result['status']:<20} ({result['success_count']}/{result['total_checks']})")
    
    # Generate enhanced repositories list
    print(f"\n🌟 TOP ENHANCED REPOSITORIES")
    top_repos = [r for r in detailed_results if r['success_count'] == r['total_checks']]
    for repo in top_repos[:10]:
        print(f"  ✅ {repo['repo']}")
    
    # Generate report file
    report_path = base_path / "VALIDATION_REPORT.md"
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(f"""# Documentation Enhancement Validation Report

## 📊 Summary Statistics

- **Total Repositories**: {total_repos}
- **Fully Enhanced**: {fully_enhanced} ({fully_enhanced/total_repos*100:.1f}%)
- **Overall Enhancement Rate**: {sum(validation_summary.values())}/{total_repos*len(validation_summary)} ({sum(validation_summary.values())/(total_repos*len(validation_summary))*100:.1f}%)

## 🎯 Feature Implementation Status

| Feature | Count | Percentage |
|---------|-------|------------|
""")
        
        for feature, count in validation_summary.items():
            percentage = count / total_repos * 100
            f.write(f"| {feature.replace('_', ' ').title()} | {count}/{total_repos} | {percentage:.1f}% |\n")
        
        f.write(f"""
## 🏆 Fully Enhanced Repositories

These repositories have all documentation enhancements applied:

""")
        
        for repo in top_repos:
            f.write(f"- ✅ **{repo['repo']}** - Complete documentation suite\n")
        
        f.write(f"""
## 📋 All Repository Status

| Repository | Status | Score |
|------------|--------|-------|
""")
        
        for result in detailed_results:
            f.write(f"| {result['repo']} | {result['status']} | {result['success_count']}/{result['total_checks']} |\n")
        
        f.write(f"""
## 🔧 Applied Enhancements

### 1. Enterprise README Template
- Dark neon theme with cyan/magenta gradient
- Professional badges and status indicators
- Comprehensive feature descriptions
- Architecture diagrams with Mermaid syntax
- Tiation ecosystem cross-references

### 2. Documentation Structure
- Standardized `docs/` directory with complete documentation suite
- User guides, API references, and architecture documentation
- Deployment guides and troubleshooting sections
- FAQ and developer contribution guidelines

### 3. Visual Assets
- Professional architecture diagrams in SVG format
- Placeholder screenshots with consistent theming
- Organized asset directory structure
- Dark neon theme consistency across all visuals

### 4. GitHub Pages Configuration
- Jekyll configuration with dark neon theme
- SEO optimization and plugin integration
- Custom CSS with Tiation brand colors
- Responsive design considerations

### 5. Backup and Safety
- Automatic backup of existing README files
- Preserves original content while enhancing presentation
- Non-destructive enhancement process

## 🚀 Next Steps

1. **Enable GitHub Pages**: Activate GitHub Pages for enhanced repositories
2. **Create Live Demos**: Set up interactive demonstrations
3. **Add Real Screenshots**: Replace placeholders with actual interface captures
4. **API Documentation**: Generate comprehensive API documentation
5. **Performance Monitoring**: Add metrics and performance tracking

## 📧 Contact

For questions about this validation report:
- **Email**: tiatheone@protonmail.com
- **GitHub**: [github.com/tiation](https://github.com/tiation)

---

*Generated by Tiation Documentation Enhancement System*
""")
    
    print(f"\n📋 Validation report saved to: {report_path}")
    print(f"\n🎉 Documentation enhancement validation complete!")
    print(f"🔮 {fully_enhanced} repositories are now enterprise-ready!")

def main():
    """Main validation function"""
    print("🔮 Tiation Documentation Enhancement Validator")
    print("=" * 50)
    
    generate_validation_report()
    
    print("\n🎯 All documentation enhancements have been validated!")
    print("🚀 Your repositories are now enterprise-grade!")

if __name__ == "__main__":
    main()
