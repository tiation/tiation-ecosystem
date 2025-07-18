# Tiation Template Repository Usage Guide

This template repository provides a complete, production-ready React application setup with modern tooling and multiple deployment options.

## 🚀 Quick Start

### Method 1: Using the Setup Script (Recommended)

1. **Clone this template repository:**
   ```bash
   git clone https://github.com/tiation/tiation-template-repo.git your-project-name
   cd your-project-name
   ```

2. **Run the setup script:**
   ```bash
   npm run setup
   ```

3. **Follow the prompts:**
   - Enter your project name (kebab-case)
   - Enter your project description
   - Enter your repository name (optional)
   - Enter your GitHub username/organization

4. **Install dependencies:**
   ```bash
   npm install
   ```

5. **Start development:**
   ```bash
   npm run dev
   ```

### Method 2: Manual Setup

1. **Clone and customize files manually:**
   Replace the following placeholders in these files:
   - `package.json`
   - `vite.config.ts`
   - `index.html`
   - `README.md`
   - `src/components/Header.tsx`

2. **Placeholder values:**
   - `{{PROJECT_NAME}}` - Your project name
   - `{{PROJECT_DESCRIPTION}}` - Your project description
   - `{{HOMEPAGE_URL}}` - Your GitHub Pages URL
   - `{{REPOSITORY_URL}}` - Your GitHub repository URL
   - `{{REPO_NAME}}` - Your repository name
   - `{{SURGE_URL}}` - Your Surge.sh URL
   - `{{GITHUB_USER}}` - Your GitHub username

## 🎯 Features Included

### Modern Development Stack
- **React 18** with TypeScript
- **Vite** for fast development and building
- **Tailwind CSS** for styling
- **Radix UI** for accessible components
- **ESLint** for code quality

### Advanced UI Components
- Dark/Light theme support
- Responsive design
- Modern gradient effects
- Accessible components
- Custom animations

### Multiple Deployment Options
- **Surge.sh** - Fast, free static hosting
- **GitHub Pages** - Integrated with GitHub
- **Netlify** - Professional hosting platform
- **Vercel** - Optimized for React apps

## 📦 Available Scripts

```bash
# Development
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint

# Deployment
npm run deploy:surge    # Deploy to Surge.sh (recommended)
npm run deploy          # Deploy to GitHub Pages
npm run deploy:netlify  # Deploy to Netlify
npm run deploy:vercel   # Deploy to Vercel

# Setup
npm run setup          # Run template setup script
```

## 🎨 Customization

### Styling
- **Tailwind CSS**: Modify `tailwind.config.ts` for custom colors, fonts, etc.
- **Dark Theme**: Uses `next-themes` for theme switching
- **Gradients**: Cyan/Magenta gradient scheme (easily customizable)

### Components
- **Header Component**: Includes showcase navigation and branding
- **UI Components**: Pre-built accessible components in `src/components/ui/`
- **Layout**: Responsive design with mobile-first approach

### Configuration
- **Vite Config**: Supports GitHub Pages base path and development server
- **TypeScript**: Full TypeScript support with strict mode
- **ESLint**: Configured for React and TypeScript

## 🚀 Deployment Guide

### 1. Surge.sh (Recommended)
```bash
npm run deploy:surge
```
**Benefits:**
- Instant deployment
- Free SSL certificates
- Custom domain support
- Simple CLI interface

### 2. GitHub Pages
```bash
npm run deploy
```
**Benefits:**
- Integrated with GitHub
- Free hosting for public repositories
- Automatic HTTPS

### 3. Netlify
```bash
npm run deploy:netlify
```
**Benefits:**
- Advanced features (forms, functions)
- Continuous deployment
- Custom domains

### 4. Vercel
```bash
npm run deploy:vercel
```
**Benefits:**
- Optimized for React/Next.js
- Edge functions
- Analytics

## 📁 Project Structure

```
your-project/
├── public/              # Static assets
├── src/
│   ├── components/      # React components
│   │   ├── ui/         # Reusable UI components
│   │   └── Header.tsx  # Main header component
│   ├── lib/            # Utility functions
│   └── pages/          # Page components
├── package.json        # Dependencies and scripts
├── vite.config.ts      # Vite configuration
├── tailwind.config.ts  # Tailwind CSS configuration
├── setup.js           # Template setup script
└── README.md          # Project documentation
```

## 🔧 Advanced Configuration

### Custom Domains
- **Surge**: Update `CNAME` file with your domain
- **GitHub Pages**: Configure in repository settings
- **Netlify/Vercel**: Configure in their dashboards

### Environment Variables
Create `.env.local` for environment-specific variables:
```env
VITE_APP_NAME=Your App Name
VITE_API_URL=https://your-api.com
```

### Adding More Deployment Targets
Add new scripts to `package.json`:
```json
{
  "scripts": {
    "deploy:firebase": "npm run build && firebase deploy",
    "deploy:aws": "npm run build && aws s3 sync dist/ s3://your-bucket"
  }
}
```

## 🤝 Contributing to the Template

To improve this template:

1. Fork the template repository
2. Make your improvements
3. Test with multiple project types
4. Submit a pull request

## 📝 License

This template is licensed under the MIT License. Feel free to use it for any project!

## 🎉 Success Stories

This template has been used to create:
- Podcast platforms
- Portfolio sites
- Dashboard applications
- E-commerce demos
- And many more!

---

Happy coding! 🚀

For support, contact: [tiatheone@protonmail.com](mailto:tiatheone@protonmail.com)
