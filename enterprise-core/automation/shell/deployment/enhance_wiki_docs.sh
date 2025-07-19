#!/bin/bash

# Enhanced Wiki Documentation Script
# Adds comprehensive FAQs and troubleshooting sections

echo "🌟 Enhancing Wiki Documentation with Enterprise-Grade FAQs and Troubleshooting..."

# Function to add comprehensive FAQ and troubleshooting
add_comprehensive_docs() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    if [[ -d "$repo_path/docs" ]]; then
        # Create FAQ document
        cat <<EOF > "$repo_path/docs/faq.md"
# $repo_name FAQ

## 🔍 Frequently Asked Questions

### General Questions

**Q: What is $repo_name?**
A: $repo_name is an enterprise-grade solution designed for modern development workflows with dark neon theme and advanced functionality.

**Q: How do I get started?**
A: Follow our comprehensive [User Guide](user-guide.md) and [Deployment Guide](deployment.md).

**Q: Is this project actively maintained?**
A: Yes, this project is actively maintained with regular updates and enterprise-grade support.

### Technical Questions

**Q: What are the system requirements?**
A: See our [Architecture Guide](architecture.md) for detailed system requirements.

**Q: How do I contribute to this project?**
A: Check our contributing guidelines in the main README.md file.

**Q: Where can I find API documentation?**
A: Comprehensive API documentation is available in our [API Reference](api-reference.md).

### Advanced Questions

**Q: Can I customize the dark neon theme?**
A: Yes, the dark neon theme is fully customizable. Check our theming documentation.

**Q: How do I integrate with existing systems?**
A: See our integration guides in the documentation directory.

**Q: What support options are available?**
A: We offer community support through GitHub issues and enterprise support options.

EOF

        # Create troubleshooting document
        cat <<EOF > "$repo_path/docs/troubleshooting.md"
# $repo_name Troubleshooting Guide

## 🛠️ Common Issues and Solutions

### Installation Issues

**Issue: Installation fails with dependency errors**
- **Solution**: 
  - Ensure you have the latest Node.js version (>= 18.0.0)
  - Clear npm cache: \`npm cache clean --force\`
  - Delete node_modules and reinstall: \`rm -rf node_modules && npm install\`

**Issue: Permission denied errors**
- **Solution**: 
  - Use proper permissions: \`sudo chown -R \$(whoami) ~/.npm\`
  - Avoid using sudo with npm install

### Configuration Issues

**Issue: Environment variables not loading**
- **Solution**: 
  - Check .env file exists and has proper formatting
  - Verify environment variable names match documentation
  - Restart the application after changes

**Issue: Dark theme not applying**
- **Solution**: 
  - Clear browser cache
  - Check CSS imports are correct
  - Verify theme configuration files

### Runtime Issues

**Issue: Application crashes on startup**
- **Solution**: 
  - Check logs for detailed error messages
  - Verify all dependencies are installed
  - Ensure database/external services are running

**Issue: Performance issues**
- **Solution**: 
  - Check system resources (CPU, memory)
  - Optimize database queries
  - Review caching configurations

### Development Issues

**Issue: Hot reload not working**
- **Solution**: 
  - Check file watchers aren't at system limits
  - Verify development server configuration
  - Restart development server

**Issue: Build failures**
- **Solution**: 
  - Check for TypeScript errors
  - Verify all imports are correct
  - Clear build cache and retry

### Deployment Issues

**Issue: Deployment fails**
- **Solution**: 
  - Check deployment logs
  - Verify environment variables are set
  - Ensure proper build artifacts

**Issue: SSL/TLS errors**
- **Solution**: 
  - Verify certificate configuration
  - Check certificate expiration
  - Ensure proper HTTPS setup

## 📞 Getting Help

If you're still experiencing issues:

1. **Check the logs** - Most issues can be diagnosed from error logs
2. **Search existing issues** - Someone might have encountered this before
3. **Create a GitHub issue** - Provide detailed information about your problem
4. **Contact support** - For enterprise customers, contact our support team

## 🔧 Debug Mode

Enable debug mode for detailed logging:
\`\`\`bash
DEBUG=* npm start
\`\`\`

## 📊 Performance Monitoring

Monitor application performance:
- Check CPU and memory usage
- Review database query performance
- Monitor network requests
- Use profiling tools for optimization

EOF

        # Update index.md to include new sections
        cat <<EOF >> "$repo_path/docs/index.md"

## 📚 Additional Resources

- [FAQ](faq.md) - Frequently asked questions
- [Troubleshooting](troubleshooting.md) - Common issues and solutions
- [Contributing](../CONTRIBUTING.md) - How to contribute to this project
- [License](../LICENSE) - Project license information

## 🎨 Theme Information

This project features a **dark neon theme** with:
- Cyan gradient flares
- Professional enterprise styling
- Mobile-responsive design
- Accessibility features

## 🚀 Quick Links

- [GitHub Repository](https://github.com/TiaAstor/$repo_name)
- [Live Demo](https://tiaastor.github.io/$repo_name)
- [Documentation](https://github.com/TiaAstor/$repo_name/wiki)
- [Issues](https://github.com/TiaAstor/$repo_name/issues)

EOF

        echo "✅ Enhanced documentation for: $repo_name"
    fi
}

# Process all repositories
for repo in $(find . -maxdepth 1 -type d ! -name "." ! -name "node_modules" ! -name ".git"); do
    add_comprehensive_docs "$repo"
done

echo "🎉 All repositories now have comprehensive FAQ and troubleshooting documentation!"
