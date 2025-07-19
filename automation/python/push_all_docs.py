#!/usr/bin/env python3
"""
Universal Documentation Push System
Pushes documentation changes to all repositories in the tiation-github folder
"""

import os
import subprocess
import sys
from pathlib import Path

def run_command(cmd, cwd=None):
    """Run a shell command and return the result"""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            cwd=cwd, 
            capture_output=True, 
            text=True,
            timeout=30
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "Command timed out"
    except Exception as e:
        return False, "", str(e)

def has_git_changes(repo_path):
    """Check if repository has uncommitted changes"""
    success, stdout, stderr = run_command("git status --porcelain", repo_path)
    return success and stdout.strip() != ""

def get_current_branch(repo_path):
    """Get the current branch name"""
    success, stdout, stderr = run_command("git branch --show-current", repo_path)
    if success:
        return stdout.strip()
    return "main"  # fallback

def push_repo_changes(repo_path, repo_name):
    """Push changes for a single repository"""
    print(f"📚 Processing {repo_name}...")
    
    # Check if it's a git repository
    if not (repo_path / ".git").exists():
        print(f"  ⚠️  Skipping {repo_name} - not a git repository")
        return False, "Not a git repository"
    
    # Check if there are changes to commit
    if not has_git_changes(repo_path):
        print(f"  ℹ️  No changes to commit in {repo_name}")
        return True, "No changes"
    
    # Get current branch
    branch = get_current_branch(repo_path)
    
    # Stage all changes
    success, stdout, stderr = run_command("git add .", repo_path)
    if not success:
        return False, f"Failed to stage changes: {stderr}"
    
    # Commit changes
    commit_msg = "📚 Enhanced documentation with enterprise-grade dark neon theme\n\n- Added comprehensive feature listings\n- Implemented professional hero sections\n- Enhanced architecture overviews\n- Added quick start guides\n- Improved performance metrics\n- Added enterprise features documentation\n- Consistent dark neon styling across all docs"
    
    success, stdout, stderr = run_command(f'git commit -m "{commit_msg}"', repo_path)
    if not success:
        return False, f"Failed to commit changes: {stderr}"
    
    # Push changes
    success, stdout, stderr = run_command(f"git push origin {branch}", repo_path)
    if not success:
        return False, f"Failed to push changes: {stderr}"
    
    print(f"  ✅ Successfully pushed {repo_name}")
    return True, "Success"

def main():
    print("🚀 Universal Documentation Push System")
    print("=" * 60)
    
    base_path = Path("/Users/tiaastor/tiation-github")
    
    if not base_path.exists():
        print("❌ tiation-github directory not found!")
        sys.exit(1)
    
    # Get all directories (potential repositories)
    repos = [d for d in base_path.iterdir() if d.is_dir() and not d.name.startswith('.')]
    repos.sort()
    
    success_count = 0
    failed_repos = []
    no_changes_count = 0
    
    print(f"📂 Found {len(repos)} repositories to process\n")
    
    for repo_path in repos:
        repo_name = repo_path.name
        
        try:
            success, message = push_repo_changes(repo_path, repo_name)
            
            if success:
                if message == "No changes":
                    no_changes_count += 1
                else:
                    success_count += 1
            else:
                failed_repos.append((repo_name, message))
                print(f"  ❌ Failed to push {repo_name}: {message}")
                
        except Exception as e:
            failed_repos.append((repo_name, str(e)))
            print(f"  ❌ Error processing {repo_name}: {e}")
    
    # Generate summary report
    print("\n" + "=" * 60)
    print("🎉 Push Operation Complete!")
    print(f"📊 Successfully pushed: {success_count}/{len(repos)} repositories")
    print(f"📊 No changes needed: {no_changes_count} repositories")
    
    if failed_repos:
        print(f"❌ Failed: {len(failed_repos)} repositories")
        print("\n⚠️  Failed repositories:")
        for repo_name, error in failed_repos:
            print(f"   - {repo_name}: {error}")
    
    # Save detailed report
    report_path = base_path / "UNIVERSAL_DOCS_PUSH_REPORT.md"
    with open(report_path, 'w') as f:
        f.write("# Universal Documentation Push Report\n\n")
        f.write(f"**Generated:** {subprocess.run(['date'], capture_output=True, text=True).stdout.strip()}\n\n")
        f.write(f"## Summary\n\n")
        f.write(f"- **Total Repositories:** {len(repos)}\n")
        f.write(f"- **Successfully Pushed:** {success_count}\n")
        f.write(f"- **No Changes Needed:** {no_changes_count}\n")
        f.write(f"- **Failed:** {len(failed_repos)}\n\n")
        
        if success_count > 0:
            f.write("## ✅ Successfully Pushed Repositories\n\n")
            for repo_path in repos:
                repo_name = repo_path.name
                if repo_name not in [r[0] for r in failed_repos]:
                    if has_git_changes(repo_path) or success_count > 0:
                        f.write(f"- {repo_name}\n")
            f.write("\n")
        
        if failed_repos:
            f.write("## ❌ Failed Repositories\n\n")
            for repo_name, error in failed_repos:
                f.write(f"- **{repo_name}:** {error}\n")
            f.write("\n")
        
        f.write("## 🎯 Next Steps\n\n")
        f.write("1. Review failed repositories and resolve any issues\n")
        f.write("2. Verify GitHub Pages are building correctly\n")
        f.write("3. Check documentation rendering on deployed sites\n")
        f.write("4. Update any CI/CD pipelines if needed\n")
    
    print(f"\n📋 Detailed report saved: {report_path}")
    print("\n🎯 Universal documentation push complete!")
    
    if failed_repos:
        print("⚠️  Please review failed repositories and resolve issues manually.")
        sys.exit(1)
    else:
        print("🚀 All repositories successfully synchronized!")

if __name__ == "__main__":
    main()
