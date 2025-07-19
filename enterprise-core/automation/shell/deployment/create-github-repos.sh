#!/bin/bash

# Script to create GitHub repositories for RiggerConnect split repos
# Make sure you have GitHub CLI installed: brew install gh
# Make sure you're logged in: gh auth login

set -e

# Define repository names and descriptions (bash 3.2 compatible)
repo_names=(
    "tiation-rigger-automation-server"
    "tiation-rigger-connect-api"
    "tiation-rigger-connect-app"
    "tiation-rigger-jobs-app"
    "tiation-rigger-infrastructure"
    "tiation-rigger-mobile-app"
    "tiation-rigger-shared-libraries"
    "tiation-rigger-metrics-dashboard"
    "tiation-rigger-workspace-docs"
)

repo_descriptions=(
    "RiggerConnect Automation Server - Handles automated workflows and job processing"
    "RiggerConnect API - Backend API service for the Connect platform"
    "RiggerConnect App - Main web application for connecting riggers and operators"
    "RiggerConnect Jobs App - Job management and marketplace application"
    "RiggerConnect Infrastructure - Infrastructure as Code and deployment configurations"
    "RiggerConnect Mobile App - Mobile application for iOS and Android"
    "RiggerConnect Shared Libraries - Common utilities and components"
    "RiggerConnect Metrics Dashboard - Analytics and monitoring dashboard"
    "RiggerConnect Documentation - Project documentation and GitHub Pages site"
)

echo "Creating GitHub repositories for RiggerConnect project..."
echo "=================================================="

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI is not installed. Install with: brew install gh"
    exit 1
fi

# Check if user is logged in
if ! gh auth status &> /dev/null; then
    echo "❌ Please login to GitHub CLI first: gh auth login"
    exit 1
fi

# Create each repository
for i in "${!repo_names[@]}"; do
    repo_name="${repo_names[$i]}"
    description="${repo_descriptions[$i]}"
    
    echo "Creating repository: $repo_name"
    echo "Description: $description"
    
    # Create the repository
    if gh repo create "$repo_name" --public --description "$description" --clone=false; then
        echo "✅ Successfully created: $repo_name"
    else
        echo "❌ Failed to create: $repo_name (may already exist)"
    fi
    
    echo "---"
done

echo "=================================================="
echo "All repositories created! Next steps:"
echo "1. Run the push script to upload your local repos"
echo "2. Configure GitHub Pages for tiation-rigger-workspace-docs"
echo "3. Set up CI/CD workflows"
