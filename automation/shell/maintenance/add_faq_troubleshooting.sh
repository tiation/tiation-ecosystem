#!/bin/bash

# Add FAQs and Troubleshooting to all repositories
# Commit and push changes to GitHub

echo "📚 Adding FAQs and Troubleshooting..."

# Loop through all directories in the current path
for repo in $(find . -maxdepth 1 -type d ! -name "." ! -name "node_modules"); do
    if [[ -d "$repo/docs" ]]; then
        # Add FAQs and Troubleshooting sections
        cat <<EOF >> "$repo/docs/index.md"

## 🔍 FAQ
- **Q1:** How to setup the project?
  - **A:** Follow the setup guide in [User Guide](user-guide.md).

- **Q2:** Where to find API documentation?
  - **A:** Refer to [API Reference](api-reference.md).

## 🛠️ Troubleshooting
- **Issue 1:** Problem with installation
  - **Solution:** Check your environment settings and see the setup instructions.

EOF
        echo "➕ FAQ and Troubleshooting added to: $(basename "$repo")"
    fi
done

# Commit and push changes
echo "🚀 Committing changes..."
git add .
git commit -m "Add FAQ and Troubleshooting sections to wiki"
git push origin main

echo "🎉 Changes pushed to GitHub!"
