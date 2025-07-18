#!/bin/bash

# Script to create wiki directories and initial markdown files for each repository
echo "🌐 Creating wiki directories and initial files for repositories..."

# Loop through all directories in the current path
for repo in $(find . -maxdepth 1 -type d ! -name "." ! -name "node_modules"); do
    if [[ -d "$repo/docs" ]]; then
        echo "❌ Wiki already exists for: $(basename "$repo")"
    else
        mkdir -p "$repo/docs"
        cat <<EOF > "$repo/docs/index.md"
# $(basename "$repo") Wiki

Welcome to the wiki for the $(basename "$repo") repository. Here you'll find documentation related to setup, development, and contribution.

## Sections

- [User Guide](user-guide.md)
- [API Reference](api-reference.md)
- [Architecture Guide](architecture.md)
- [Deployment Guide](deployment.md)

EOF
        touch "$repo/docs/user-guide.md"
        touch "$repo/docs/api-reference.md"
        touch "$repo/docs/architecture.md"
        touch "$repo/docs/deployment.md"
        echo "✅ Created wiki for: $(basename "$repo")"
    fi
done

echo "🎉 Wiki setup complete for all repositories!"
