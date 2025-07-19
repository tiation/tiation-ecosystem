#!/bin/bash

set -e

BASE_DIR="/Users/tiaastor/tiation-github"
SOURCE_DIR="$BASE_DIR/RiggerConnect-RiggerJobs-Workspace-PB"

echo "🚀 Creating split repositories for RiggerConnect workspace..."

# Function to create a repository
create_repo() {
    local repo_name="$1"
    local repo_dir="$BASE_DIR/$repo_name"
    
    echo "📁 Creating repository: $repo_name"
    
    # Create directory and initialize git
    mkdir -p "$repo_dir"
    cd "$repo_dir"
    git init
    
    # Copy specific files based on repository type
    case "$repo_name" in
        "tiation-rigger-jobs-app")
            cp -r "$SOURCE_DIR/RiggerJobsApp/"* "$repo_dir/"
            cp -r "$SOURCE_DIR/Shared/Core" "$repo_dir/src/" 2>/dev/null || true
            ;;
        "tiation-rigger-infrastructure")
            cp -r "$SOURCE_DIR/Infrastructure/"* "$repo_dir/"
            cp -r "$SOURCE_DIR/scripts/"* "$repo_dir/scripts/" 2>/dev/null || true
            cp "$SOURCE_DIR/.github" "$repo_dir/" -r 2>/dev/null || true
            ;;
        "tiation-rigger-shared-libraries")
            cp -r "$SOURCE_DIR/Shared/"* "$repo_dir/"
            ;;
        "tiation-rigger-metrics-dashboard")
            cp -r "$SOURCE_DIR/MetricsDashboard/"* "$repo_dir/"
            ;;
        "tiation-rigger-workspace-docs")
            cp -r "$SOURCE_DIR/docs/"* "$repo_dir/"
            cp -r "$SOURCE_DIR/assets/"* "$repo_dir/assets/" 2>/dev/null || true
            ;;
    esac
    
    echo "✅ Repository $repo_name created successfully"
}

# Create all repositories
create_repo "tiation-rigger-jobs-app"
create_repo "tiation-rigger-infrastructure"
create_repo "tiation-rigger-shared-libraries"
create_repo "tiation-rigger-metrics-dashboard"
create_repo "tiation-rigger-workspace-docs"

echo "🎉 All repositories created successfully!"
echo ""
echo "📋 Summary:"
echo "  - tiation-rigger-automation-server (✅ already created)"
echo "  - tiation-rigger-connect-app (✅ already created)"
echo "  - tiation-rigger-jobs-app (✅ created)"
echo "  - tiation-rigger-infrastructure (✅ created)"
echo "  - tiation-rigger-shared-libraries (✅ created)"
echo "  - tiation-rigger-metrics-dashboard (✅ created)"
echo "  - tiation-rigger-workspace-docs (✅ created)"
echo ""
echo "🔗 Next steps:"
echo "  1. Add remote repositories to each local repo"
echo "  2. Configure CI/CD pipelines"
echo "  3. Update cross-repository dependencies"
echo "  4. Test deployment processes"
