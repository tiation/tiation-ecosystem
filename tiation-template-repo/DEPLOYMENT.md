# Deployment Guide

## Available Deployment Options

### 1. Surge.sh (Recommended)
```bash
npm run deploy:surge
```
Your site will be available at: https://tiation-test.surge.sh

### 2. GitHub Pages
```bash
npm run deploy
```
Your site will be available at: https://tiation.github.io/test

### 3. Netlify
```bash
npm run deploy:netlify
```

### 4. Vercel
```bash
npm run deploy:vercel
```

## First Time Setup
1. Run `npm install` to install dependencies
2. Run `npm run dev` to start development server
3. Build with `npm run build`
4. Deploy with any of the above commands

## Custom Domain Setup
- For Surge: Update the CNAME file with your custom domain
- For GitHub Pages: Configure in repository settings
- For Netlify/Vercel: Configure in their respective dashboards
