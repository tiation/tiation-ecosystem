#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import readline from 'readline';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function question(query) {
  return new Promise((resolve) => rl.question(query, resolve));
}

async function setup() {
  console.log('🚀 Welcome to the Tiation Project Template Setup!\n');
  
  // Get project details
  const projectName = await question('Enter your project name (kebab-case): ');
  const projectDescription = await question('Enter your project description: ');
  const repoName = await question('Enter your repository name (same as project name if not specified): ') || projectName;
  const githubUser = await question('Enter your GitHub username/organization: ');
  
  // Generate URLs
  const repositoryUrl = `https://github.com/${githubUser}/${repoName}.git`;
  const homepageUrl = `https://${githubUser}.github.io/${repoName}`;
  const surgeUrl = `https://${githubUser}-${repoName}.surge.sh`;
  
  console.log('\n📝 Configuration Summary:');
  console.log(`Project Name: ${projectName}`);
  console.log(`Description: ${projectDescription}`);
  console.log(`Repository: ${repositoryUrl}`);
  console.log(`GitHub Pages: ${homepageUrl}`);
  console.log(`Surge URL: ${surgeUrl}`);
  
  const confirm = await question('\nProceed with setup? (y/n): ');
  if (confirm.toLowerCase() !== 'y') {
    console.log('Setup cancelled.');
    rl.close();
    return;
  }
  
  // Define replacement mappings
  const replacements = {
    '{{PROJECT_NAME}}': projectName,
    '{{PROJECT_DESCRIPTION}}': projectDescription,
    '{{HOMEPAGE_URL}}': homepageUrl,
    '{{REPOSITORY_URL}}': repositoryUrl,
    '{{REPO_NAME}}': repoName,
    '{{SURGE_URL}}': surgeUrl,
    '{{GITHUB_USER}}': githubUser,
  };
  
  // Files to process
  const filesToProcess = [
    'package.json',
    'vite.config.ts',
    'index.html',
    'README.md',
    'src/components/Header.tsx',
  ];
  
  // Process each file
  filesToProcess.forEach((file) => {
    const filePath = path.join(__dirname, file);
    if (fs.existsSync(filePath)) {
      let content = fs.readFileSync(filePath, 'utf8');
      
      // Replace all placeholders
      Object.entries(replacements).forEach(([placeholder, value]) => {
        content = content.replace(new RegExp(placeholder, 'g'), value);
      });
      
      fs.writeFileSync(filePath, content);
      console.log(`✅ Updated ${file}`);
    } else {
      console.log(`⚠️  ${file} not found, skipping...`);
    }
  });
  
  // Create CNAME file for Surge
  const cnameContent = surgeUrl.replace('https://', '');
  fs.writeFileSync(path.join(__dirname, 'CNAME'), cnameContent);
  console.log('✅ Created CNAME file for Surge deployment');
  
  // Create deployment guide
  const deploymentGuide = `# Deployment Guide

## Available Deployment Options

### 1. Surge.sh (Recommended)
\`\`\`bash
npm run deploy:surge
\`\`\`
Your site will be available at: ${surgeUrl}

### 2. GitHub Pages
\`\`\`bash
npm run deploy
\`\`\`
Your site will be available at: ${homepageUrl}

### 3. Netlify
\`\`\`bash
npm run deploy:netlify
\`\`\`

### 4. Vercel
\`\`\`bash
npm run deploy:vercel
\`\`\`

## First Time Setup
1. Run \`npm install\` to install dependencies
2. Run \`npm run dev\` to start development server
3. Build with \`npm run build\`
4. Deploy with any of the above commands

## Custom Domain Setup
- For Surge: Update the CNAME file with your custom domain
- For GitHub Pages: Configure in repository settings
- For Netlify/Vercel: Configure in their respective dashboards
`;
  
  fs.writeFileSync(path.join(__dirname, 'DEPLOYMENT.md'), deploymentGuide);
  console.log('✅ Created DEPLOYMENT.md guide');
  
  console.log('\n🎉 Setup complete! Next steps:');
  console.log('1. Run: npm install');
  console.log('2. Run: npm run dev (to start development)');
  console.log('3. Run: npm run deploy:surge (to deploy to Surge)');
  console.log('\nHappy coding! 🚀');
  
  rl.close();
}

setup().catch(console.error);
