#!/bin/bash

# Tiation Mass Repository Upgrade Script
# Systematically upgrades all repositories to enterprise-grade standards

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USER="tiation"
BASE_DIR="$HOME/tiation-github"
UPGRADE_SCRIPT_PATH="$BASE_DIR/tiation-terminal-workflows/scripts/upgrade-to-enterprise.sh"
LOG_FILE="$BASE_DIR/mass-upgrade.log"

echo -e "${CYAN}🚀 Tiation Mass Repository Upgrade System${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "${BLUE}Base Directory: ${BASE_DIR}${NC}"
echo -e "${BLUE}Log File: ${LOG_FILE}${NC}"

# Function to print section headers
print_section() {
    echo -e "\n${BLUE}📋 $1${NC}"
    echo -e "${BLUE}$(printf '%*s' ${#1} '' | tr ' ' '-')${NC}"
}

# Function to log messages
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Function to check if repository needs upgrade
needs_upgrade() {
    local repo_path="$1"
    
    # Check for enterprise-grade indicators
    if [[ -f "$repo_path/CONTRIBUTING.md" ]] && \
       [[ -f "$repo_path/SECURITY.md" ]] && \
       [[ -d "$repo_path/.github/workflows" ]] && \
       [[ -d "$repo_path/docs/wiki" ]]; then
        return 1  # Already upgraded
    fi
    
    return 0  # Needs upgrade
}

# Function to upgrade a single repository
upgrade_repository() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    print_section "Upgrading Repository: $repo_name"
    
    log_message "Starting upgrade of $repo_name"
    
    cd "$repo_path"
    
    # Check if already upgraded
    if ! needs_upgrade "$repo_path"; then
        echo -e "${YELLOW}⚠️  Repository $repo_name already appears to be enterprise-grade${NC}"
        log_message "Repository $repo_name already upgraded - skipping"
        return 0
    fi
    
    # Copy upgrade script if it doesn't exist
    if [[ ! -f "$repo_path/scripts/upgrade-to-enterprise.sh" ]]; then
        mkdir -p "$repo_path/scripts"
        cp "$UPGRADE_SCRIPT_PATH" "$repo_path/scripts/"
        chmod +x "$repo_path/scripts/upgrade-to-enterprise.sh"
        log_message "Copied upgrade script to $repo_name"
    fi
    
    # Run the upgrade script
    if ./scripts/upgrade-to-enterprise.sh; then
        echo -e "${GREEN}✅ Successfully upgraded $repo_name${NC}"
        log_message "Successfully upgraded $repo_name"
        
        # Commit changes if this is a git repository
        if [[ -d ".git" ]]; then
            git add .
            git commit -m "🚀 Upgrade to enterprise-grade standards

Features:
- Enterprise-grade README with dark neon theme
- Comprehensive contributing guidelines
- Security policy and issue templates
- GitHub Actions CI/CD workflow
- Professional documentation structure
- MIT license and proper gitignore
- Dark neon theme with cyan gradient branding" 2>/dev/null || true
            
            log_message "Committed changes for $repo_name"
        fi
        
        return 0
    else
        echo -e "${RED}❌ Failed to upgrade $repo_name${NC}"
        log_message "Failed to upgrade $repo_name"
        return 1
    fi
}

# Function to get repository priority
get_repo_priority() {
    local repo_name="$1"
    
    # High priority repositories
    case "$repo_name" in
        "tiation-terminal-workflows") echo 1 ;;
        "tiation-docker-debian") echo 1 ;;
        "tiation-macos-networking-guide") echo 1 ;;
        "tiation-ai-platform") echo 1 ;;
        "tiation-ai-agents") echo 1 ;;
        "tiation-github-pages-theme") echo 1 ;;
        "tiation-parrot-security-guide-au") echo 2 ;;
        "tiation-automation-workspace") echo 2 ;;
        "tiation-rigger-workspace") echo 2 ;;
        "ubuntu-dev-setup") echo 2 ;;
        "liberation-system") echo 2 ;;
        *) echo 3 ;;
    esac
}

# Function to get all repositories sorted by priority
get_repositories() {
    local repos=()
    
    # Find all git repositories
    while IFS= read -r -d '' repo; do
        repo_name=$(basename "$repo")
        priority=$(get_repo_priority "$repo_name")
        repos+=("$priority:$repo")
    done < <(find "$BASE_DIR" -name ".git" -type d -print0 | sed 's/\/.git//' | sort -z)
    
    # Sort by priority and return paths
    printf '%s\n' "${repos[@]}" | sort -n | cut -d: -f2-
}

# Function to create summary report
create_summary_report() {
    local total_repos="$1"
    local upgraded_repos="$2"
    local failed_repos="$3"
    local skipped_repos="$4"
    
    print_section "Mass Upgrade Summary Report"
    
    echo -e "${CYAN}📊 Upgrade Statistics:${NC}"
    echo -e "   • Total Repositories: $total_repos"
    echo -e "   • Successfully Upgraded: ${GREEN}$upgraded_repos${NC}"
    echo -e "   • Failed Upgrades: ${RED}$failed_repos${NC}"
    echo -e "   • Already Upgraded: ${YELLOW}$skipped_repos${NC}"
    echo -e "   • Success Rate: $(( (upgraded_repos * 100) / total_repos ))%"
    
    echo -e "\n${CYAN}📋 Next Steps:${NC}"
    echo -e "   1. Review upgrade logs: ${LOG_FILE}"
    echo -e "   2. Test GitHub Actions workflows"
    echo -e "   3. Set up GitHub Pages for each repository"
    echo -e "   4. Update repository descriptions"
    echo -e "   5. Add screenshots and documentation"
    
    echo -e "\n${CYAN}🔗 Enterprise Standards Applied:${NC}"
    echo -e "   • Professional README with dark neon theme"
    echo -e "   • GitHub Actions CI/CD workflows"
    echo -e "   • Issue templates and PR guidelines"
    echo -e "   • Security policies and contributing guides"
    echo -e "   • MIT license and proper gitignore"
    echo -e "   • Documentation structure and wiki"
    
    log_message "Mass upgrade completed - $upgraded_repos/$total_repos repositories upgraded successfully"
}

# Function to push changes to all repositories
push_all_changes() {
    print_section "Pushing Changes to GitHub"
    
    local push_count=0
    local push_failed=0
    
    while IFS= read -r repo_path; do
        repo_name=$(basename "$repo_path")
        
        if [[ -d "$repo_path/.git" ]]; then
            echo -e "${YELLOW}📤 Pushing changes for $repo_name...${NC}"
            
            cd "$repo_path"
            
            if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
                echo -e "${GREEN}✅ Successfully pushed $repo_name${NC}"
                ((push_count++))
                log_message "Successfully pushed $repo_name to GitHub"
            else
                echo -e "${RED}❌ Failed to push $repo_name${NC}"
                ((push_failed++))
                log_message "Failed to push $repo_name to GitHub"
            fi
        fi
    done < <(get_repositories)
    
    echo -e "\n${CYAN}📤 Push Summary:${NC}"
    echo -e "   • Successfully Pushed: ${GREEN}$push_count${NC}"
    echo -e "   • Failed Pushes: ${RED}$push_failed${NC}"
}

# Main execution function
main() {
    local start_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    log_message "Starting mass repository upgrade at $start_time"
    
    # Check if upgrade script exists
    if [[ ! -f "$UPGRADE_SCRIPT_PATH" ]]; then
        echo -e "${RED}❌ Upgrade script not found at $UPGRADE_SCRIPT_PATH${NC}"
        echo -e "${YELLOW}Please run this script from the tiation-github directory${NC}"
        exit 1
    fi
    
    # Initialize counters
    local total_repos=0
    local upgraded_repos=0
    local failed_repos=0
    local skipped_repos=0
    
    # Get all repositories
    local repos=()
    while IFS= read -r repo_path; do
        repos+=("$repo_path")
    done < <(get_repositories)
    total_repos=${#repos[@]}
    
    echo -e "${CYAN}Found $total_repos repositories to process${NC}"
    
    # Process each repository
    for repo_path in "${repos[@]}"; do
        repo_name=$(basename "$repo_path")
        
        if [[ -d "$repo_path" ]]; then
            if upgrade_repository "$repo_path"; then
                if needs_upgrade "$repo_path"; then
                    ((upgraded_repos++))
                else
                    ((skipped_repos++))
                fi
            else
                ((failed_repos++))
            fi
        else
            echo -e "${RED}❌ Repository path not found: $repo_path${NC}"
            ((failed_repos++))
        fi
        
        echo -e "${BLUE}Progress: $((upgraded_repos + failed_repos + skipped_repos))/$total_repos${NC}"
    done
    
    # Create summary report
    create_summary_report "$total_repos" "$upgraded_repos" "$failed_repos" "$skipped_repos"
    
    # Ask if user wants to push changes
    echo -e "\n${CYAN}🤔 Would you like to push all changes to GitHub? (y/n)${NC}"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        push_all_changes
    fi
    
    local end_time=$(date '+%Y-%m-%d %H:%M:%S')
    log_message "Mass upgrade completed at $end_time"
    
    echo -e "\n${GREEN}🎉 Mass repository upgrade completed!${NC}"
    echo -e "${CYAN}📋 Check the log file for details: ${LOG_FILE}${NC}"
}

# Handle script interruption
trap 'echo -e "\n${RED}❌ Script interrupted by user${NC}"; exit 1' INT

# Check if we're in the right directory
if [[ ! -d "$BASE_DIR" ]]; then
    echo -e "${RED}❌ Base directory not found: $BASE_DIR${NC}"
    exit 1
fi

# Run main function
main "$@"
