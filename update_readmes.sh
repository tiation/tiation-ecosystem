#!/bin/bash

# Define the function to update README
update_readme() {
  local repo_dir="$1"
  local readme_path="$repo_dir/README.md"
  
  if [[ -f "$readme_path" ]]; then
    echo "Updating README for $repo_dir"

    # Backup existing README
    cp "$readme_path" "$readme_path.backup"

    # Append the human-friendly message to the README
    cat << EOF >> "$readme_path"

## 🎭 The Story Behind This Project

This repository started as a collection of ideas. It quickly grew into something more meaningful—a collaborative effort from dedicated individuals who believe in making things better, faster, and more enjoyable.

### Why It Exists

- **To Solve a Common Problem**: Each of us faced a similar challenge, so we crafted this to make life easier.
- **To Share Knowledge**: Open source is about sharing what we learn and how we solve problems.
- **To Empower Developers**: You should spend your time innovating, not reinventing the wheel. This is our small contribution to that vision.

### What You Can Expect

- **Well-Documented Code**: We believe in clear, understandable documentation so you can get up to speed quickly.
- **Community**: Join our community, contribute, and improve the project together.
- **Continuous Improvement**: We are committed to making this project better over time with your help and feedback.

**Happy coding and contributing!**

---
EOF

    echo "README updated for $repo_dir"
  else
    echo "No README found in $repo_dir"
  fi
}

# List of directories to update
repos=(
  "tiation-active-directory-setup"
  "tiation-afl-fantasy-manager-docs"
  "tiation-ai-agents"
  "tiation-ai-code-assistant"
  "tiation-ai-platform"
  "tiation-alma-street-project"
  "tiation-ansible-enterprise"
  "tiation-automation-workspace"
  "tiation-chase-white-rabbit-ngo"
  "tiation-claude-desktop-linux"
)

# Directory where repositories are located
base_dir="/Users/tiaastor/tiation-github"

# Iterate over repositories and update their READMEs
for repo in "${repos[@]}"; do
  update_readme "$base_dir/$repo"
done

