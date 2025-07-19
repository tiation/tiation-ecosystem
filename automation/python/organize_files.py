#!/usr/bin/env python3
"""
Automated File Organization Script for Tiation GitHub Directory

This script reorganizes the messy file structure into a clean, professional layout
that reflects enterprise-grade standards while preserving all functionality.
"""

import os
import shutil
import sys
from pathlib import Path
from typing import Dict, List, Tuple
import re

class FileOrganizer:
    def __init__(self, base_path: str = "/Users/tiaastor/tiation-github"):
        self.base_path = Path(base_path)
        self.moved_files = []
        self.archived_files = []
        self.duplicate_files = []
        
        # Define the organization structure
        self.organization_map = {
            # Automation Scripts
            "automation/scripts/enhancement/": [
                "enhance_all_docs.py",
                "generate_architecture_diagrams.py",
                "validate_documentation.py",
                "fix_all_incoherence.py",
                "enhance_interactive_demos.py",
                "generate_svg_diagrams.py"
            ],
            "automation/scripts/setup/": [
                "enable_github_pages.sh",
                "setup_github_pages.sh",
                "setup_universal_github_pages.sh",
                "setup_pages_simple.sh",
                "initialize_and_push_repos.sh",
                "final_github_pages_enable.sh"
            ],
            "automation/scripts/maintenance/": [
                "apply_branding.py",
                "apply_branding_simple.sh",
                "apply_unified_branding.sh",
                "coherence_check.py",
                "upgrade_repos.sh",
                "upgrade_readmes.sh",
                "push_all_repos.sh",
                "push_branding_changes.sh",
                "test_and_check.py",
                "fix_branding_issues.py"
            ],
            "automation/scripts/screenshots/": [
                "create_placeholder_screenshots.sh"
            ],
            
            # Documentation
            "documentation/reports/": [
                "DOCUMENTATION_ENHANCEMENT_REPORT.md",
                "COHERENCE_SUMMARY.md",
                "VALIDATION_REPORT.md",
                "ENTERPRISE_UPGRADE_SUMMARY.md",
                "REPOSITORY_ENHANCEMENT_SUMMARY.md",
                "GITHUB_REPOS_CREATION_SUMMARY.md",
                "TEST_SUMMARY.md",
                "SYNC_REPORT.md",
                "THREE_SITE_STRUCTURE_REPORT.md"
            ],
            "documentation/guides/": [
                "ECOSYSTEM_CONNECTIVITY.md",
                "GITHUB_PINNING_GUIDE.md",
                "PINNING_QUICK_REFERENCE.md",
                "dependency-management.md",
                "cross-reference-summary.md",
                "enterprise-upgrade-plan.md",
                "pinned-repos-enhancement-plan.md"
            ],
            "documentation/structure/": [
                "DOCUMENTATION_STRUCTURE.md",
                "REPOSITORY_INDEX.md",
                "REPOSITORY_GRAPH.md"
            ],
            "documentation/infrastructure/": [
                "INFRASTRUCTURE_DOCUMENTATION.md"
            ],
            "documentation/business/": [
                "monetization-strategy.md",
                "monetization-implementation-checklist.md",
                "MVP_STRATEGY_PLAN.md"
            ],
            
            # Templates
            "templates/readme/": [
                "enterprise_readme_template.md",
                "API_DOCS_TEMPLATE.md"
            ],
            "templates/configs/": [
                ".github-workflow-template.yml",
                ".eslintrc-template.js",
                ".gitignore-template",
                ".pre-commit-config-template.yaml",
                ".prettierrc-template.js",
                ".env.example-template",
                "Caddyfile"
            ],
            "templates/branding/": [
                # Will move BRANDING_TEMPLATES directory
            ],
            
            # Assets
            "assets/logos/": [
                "tiation-logo.svg"
            ],
            "assets/architecture-diagrams/": [
                # Will move architecture-diagrams directory
            ],
            "assets/screenshots/": [
                # Will move .screenshots directory
            ],
            
            # Utilities
            "utilities/deployment/": [
                # Future deployment scripts
            ],
            "utilities/monitoring/": [
                # Future monitoring scripts
            ],
            "utilities/testing/": [
                # Future testing scripts
            ],
            
            # Backups
            "backups/readme-backups/": [
                "README.md.backup",
                "README.md.backup.*"
            ],
            "backups/config-backups/": [
                "*.backup",
                "*_old.*"
            ],
            "backups/logs/": [
                "*.log",
                "mass-upgrade.log"
            ]
        }
        
        # Files to archive (old/backup files)
        self.archive_patterns = [
            r".*\.backup$",
            r".*_old\..*$",
            r".*\.log$",
            r"generate_architecture_diagrams_old\.py$"
        ]
        
        # Files to potentially remove (obsolete/duplicate)
        self.remove_candidates = [
            "update_readmes.sh",  # Superseded by enhance_all_docs.py
        ]
    
    def create_directory_structure(self):
        """Create the organized directory structure"""
        print("📁 Creating directory structure...")
        
        for directory in self.organization_map.keys():
            dir_path = self.base_path / directory
            dir_path.mkdir(parents=True, exist_ok=True)
            print(f"  ✅ Created: {directory}")
        
        # Create additional directories for special cases
        special_dirs = [
            "templates/branding",
            "assets/architecture-diagrams",
            "assets/screenshots",
            "utilities/deployment",
            "utilities/monitoring",
            "utilities/testing",
            "backups/readme-backups",
            "backups/config-backups",
            "backups/logs"
        ]
        
        for directory in special_dirs:
            dir_path = self.base_path / directory
            dir_path.mkdir(parents=True, exist_ok=True)
            print(f"  ✅ Created: {directory}")
    
    def move_files_to_categories(self):
        """Move files to their appropriate categories"""
        print("\n📂 Moving files to organized structure...")
        
        for target_dir, file_list in self.organization_map.items():
            target_path = self.base_path / target_dir
            
            for file_pattern in file_list:
                # Handle glob patterns
                if '*' in file_pattern:
                    matching_files = list(self.base_path.glob(file_pattern))
                    for file_path in matching_files:
                        if file_path.is_file():
                            self.move_file(file_path, target_path / file_path.name)
                else:
                    # Handle exact file names
                    source_file = self.base_path / file_pattern
                    if source_file.exists() and source_file.is_file():
                        self.move_file(source_file, target_path / file_pattern)
    
    def move_special_directories(self):
        """Move special directories like BRANDING_TEMPLATES"""
        print("\n📁 Moving special directories...")
        
        # Move BRANDING_TEMPLATES
        branding_source = self.base_path / "BRANDING_TEMPLATES"
        branding_target = self.base_path / "templates/branding/BRANDING_TEMPLATES"
        if branding_source.exists():
            self.move_directory(branding_source, branding_target)
        
        # Move architecture-diagrams
        arch_source = self.base_path / "architecture-diagrams"
        arch_target = self.base_path / "assets/architecture-diagrams"
        if arch_source.exists():
            self.move_directory(arch_source, arch_target)
        
        # Move .screenshots
        screenshots_source = self.base_path / ".screenshots"
        screenshots_target = self.base_path / "assets/screenshots"
        if screenshots_source.exists():
            self.move_directory(screenshots_source, screenshots_target)
        
        # Move monetization-templates
        monetization_source = self.base_path / "monetization-templates"
        monetization_target = self.base_path / "templates/monetization-templates"
        if monetization_source.exists():
            self.move_directory(monetization_source, monetization_target)
    
    def archive_backup_files(self):
        """Archive backup and obsolete files"""
        print("\n🗄️ Archiving backup files...")
        
        # Find all files matching archive patterns
        for pattern in self.archive_patterns:
            matching_files = []
            for file_path in self.base_path.iterdir():
                if file_path.is_file() and re.match(pattern, file_path.name):
                    matching_files.append(file_path)
            
            for file_path in matching_files:
                if file_path.name.endswith('.backup') or '_old' in file_path.name:
                    target_dir = self.base_path / "backups/readme-backups"
                elif file_path.name.endswith('.log'):
                    target_dir = self.base_path / "backups/logs"
                else:
                    target_dir = self.base_path / "backups/config-backups"
                
                self.move_file(file_path, target_dir / file_path.name)
    
    def move_file(self, source: Path, target: Path):
        """Move a single file with safety checks"""
        try:
            if target.exists():
                print(f"  ⚠️  Target exists: {target.name}")
                return
            
            shutil.move(str(source), str(target))
            self.moved_files.append((str(source), str(target)))
            print(f"  ✅ Moved: {source.name} → {target.parent.name}/")
        except Exception as e:
            print(f"  ❌ Error moving {source.name}: {e}")
    
    def move_directory(self, source: Path, target: Path):
        """Move a directory with safety checks"""
        try:
            if target.exists():
                print(f"  ⚠️  Target directory exists: {target.name}")
                return
            
            shutil.move(str(source), str(target))
            print(f"  ✅ Moved directory: {source.name} → {target.parent.name}/")
        except Exception as e:
            print(f"  ❌ Error moving directory {source.name}: {e}")
    
    def create_index_files(self):
        """Create index files for easy navigation"""
        print("\n📋 Creating index files...")
        
        # Main index file
        main_index = self.base_path / "INDEX.md"
        main_index_content = """# Tiation GitHub Directory Index

## 🏗️ Directory Structure

### 🤖 Automation
- **[automation/scripts/enhancement/](automation/scripts/enhancement/)** - Documentation enhancement scripts
- **[automation/scripts/setup/](automation/scripts/setup/)** - Repository setup scripts
- **[automation/scripts/maintenance/](automation/scripts/maintenance/)** - Maintenance and branding scripts
- **[automation/scripts/screenshots/](automation/scripts/screenshots/)** - Screenshot generation scripts

### 📚 Documentation
- **[documentation/reports/](documentation/reports/)** - Enhancement and validation reports
- **[documentation/guides/](documentation/guides/)** - Setup and usage guides
- **[documentation/structure/](documentation/structure/)** - Repository structure documentation
- **[documentation/infrastructure/](documentation/infrastructure/)** - Infrastructure documentation
- **[documentation/business/](documentation/business/)** - Business and monetization docs

### 📄 Templates
- **[templates/readme/](templates/readme/)** - README templates
- **[templates/configs/](templates/configs/)** - Configuration file templates
- **[templates/branding/](templates/branding/)** - Branding templates and assets

### 🎨 Assets
- **[assets/logos/](assets/logos/)** - Logo files and branding assets
- **[assets/architecture-diagrams/](assets/architecture-diagrams/)** - Architecture diagrams
- **[assets/screenshots/](assets/screenshots/)** - Screenshot assets

### 🔧 Utilities
- **[utilities/deployment/](utilities/deployment/)** - Deployment utilities
- **[utilities/monitoring/](utilities/monitoring/)** - Monitoring tools
- **[utilities/testing/](utilities/testing/)** - Testing utilities

### 🗄️ Backups
- **[backups/readme-backups/](backups/readme-backups/)** - README backup files
- **[backups/config-backups/](backups/config-backups/)** - Configuration backups
- **[backups/logs/](backups/logs/)** - Log files

### 📁 Repositories
- **Individual repository directories** - All your project repositories

## 🚀 Quick Start

1. **Documentation Enhancement**: Use `automation/scripts/enhancement/enhance_all_docs.py`
2. **Architecture Diagrams**: Use `automation/scripts/enhancement/generate_architecture_diagrams.py`
3. **Setup GitHub Pages**: Use `automation/scripts/setup/setup_github_pages.sh`
4. **Validation**: Use `automation/scripts/enhancement/validate_documentation.py`

## 📧 Contact

For questions about this organization:
- **Email**: tiatheone@protonmail.com
- **GitHub**: [github.com/tiation](https://github.com/tiation)

---

*Organized by Tiation File Organization System*
"""
        
        with open(main_index, 'w', encoding='utf-8') as f:
            f.write(main_index_content)
        
        print("  ✅ Created: INDEX.md")
        
        # Create automation index
        automation_index = self.base_path / "automation/README.md"
        automation_index_content = """# Automation Scripts

## 🔧 Enhancement Scripts
- **enhance_all_docs.py** - Enhance all repository documentation
- **generate_architecture_diagrams.py** - Generate architecture diagrams
- **validate_documentation.py** - Validate documentation enhancements
- **fix_all_incoherence.py** - Fix documentation inconsistencies

## ⚙️ Setup Scripts
- **setup_github_pages.sh** - Setup GitHub Pages for repositories
- **enable_github_pages.sh** - Enable GitHub Pages automation
- **initialize_and_push_repos.sh** - Initialize and push repositories

## 🛠️ Maintenance Scripts
- **apply_branding.py** - Apply consistent branding
- **coherence_check.py** - Check documentation coherence
- **upgrade_repos.sh** - Upgrade repository structure

## 📸 Screenshot Scripts
- **create_placeholder_screenshots.sh** - Create placeholder screenshots

## Usage

All scripts are designed to be run from the main tiation-github directory:

```bash
cd /Users/tiaastor/tiation-github
python3 automation/scripts/enhancement/enhance_all_docs.py
```
"""
        
        with open(automation_index, 'w', encoding='utf-8') as f:
            f.write(automation_index_content)
        
        print("  ✅ Created: automation/README.md")
    
    def update_script_references(self):
        """Update hardcoded paths in scripts"""
        print("\n🔄 Updating script references...")
        
        # This would need to be implemented to update hardcoded paths
        # For now, just print a reminder
        print("  ⚠️  Remember to update hardcoded paths in moved scripts!")
    
    def generate_organization_report(self):
        """Generate a report of the organization process"""
        print("\n📊 Generating organization report...")
        
        report_path = self.base_path / "documentation/reports/FILE_ORGANIZATION_REPORT.md"
        
        report_content = f"""# File Organization Report

## 📊 Organization Summary

### Files Moved: {len(self.moved_files)}

| Source | Target |
|--------|--------|
"""
        
        for source, target in self.moved_files:
            source_name = Path(source).name
            target_dir = Path(target).parent.name
            report_content += f"| {source_name} | {target_dir}/ |\n"
        
        report_content += f"""
## 🏗️ Directory Structure Created

- automation/scripts/enhancement/
- automation/scripts/setup/
- automation/scripts/maintenance/
- automation/scripts/screenshots/
- documentation/reports/
- documentation/guides/
- documentation/structure/
- documentation/infrastructure/
- documentation/business/
- templates/readme/
- templates/configs/
- templates/branding/
- assets/logos/
- assets/architecture-diagrams/
- assets/screenshots/
- utilities/deployment/
- utilities/monitoring/
- utilities/testing/
- backups/readme-backups/
- backups/config-backups/
- backups/logs/

## 🎯 Benefits Achieved

1. **Clean Root Directory**: No more loose files
2. **Logical Organization**: Files grouped by purpose
3. **Professional Structure**: Enterprise-grade organization
4. **Easy Navigation**: Clear directory hierarchy
5. **Maintainability**: Easy to find and update files

## 🚀 Next Steps

1. Update hardcoded paths in scripts
2. Test all automation scripts
3. Update documentation references
4. Train team on new structure
5. Implement file naming standards

---

*Generated by Tiation File Organization System*
"""
        
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        print(f"  ✅ Report saved: {report_path}")
    
    def organize_all(self):
        """Execute the complete organization process"""
        print("🔮 Tiation File Organization System")
        print("=" * 50)
        
        # Phase 1: Create structure
        self.create_directory_structure()
        
        # Phase 2: Move files
        self.move_files_to_categories()
        self.move_special_directories()
        
        # Phase 3: Archive backups
        self.archive_backup_files()
        
        # Phase 4: Create navigation
        self.create_index_files()
        
        # Phase 5: Generate report
        self.generate_organization_report()
        
        print(f"\n🎉 Organization Complete!")
        print(f"📁 Moved {len(self.moved_files)} files")
        print(f"🗂️ Created organized directory structure")
        print(f"📋 Generated INDEX.md for easy navigation")
        print(f"\n🚀 Your directory is now enterprise-ready!")

def main():
    """Main function to run the organization"""
    organizer = FileOrganizer()
    
    # Ask for confirmation
    print("🔮 Tiation File Organization System")
    print("=" * 50)
    print("This will reorganize your entire directory structure.")
    print("All files will be moved to appropriate categories.")
    print("Original files will be preserved (moved, not deleted).")
    
    response = input("\n🤔 Proceed with organization? (y/N): ")
    
    if response.lower() == 'y':
        organizer.organize_all()
    else:
        print("❌ Organization cancelled.")

if __name__ == "__main__":
    main()
