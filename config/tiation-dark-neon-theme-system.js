#!/usr/bin/env node

/**
 * Tiation Dark Neon Theme System
 * Standardized dark neon theme with consistent cyan/magenta gradients across all platforms
 * 
 * This script creates a comprehensive theme system that can be applied to:
 * - GitHub Pages (Jekyll themes)
 * - Terminal configurations (Warp, iTerm, etc.)
 * - VS Code themes
 * - Web applications (CSS/Tailwind)
 * - Documentation sites
 * 
 * Features:
 * - Consistent color palette across all platforms
 * - Animated gradients and glow effects
 * - Enterprise-grade professional appearance
 * - Accessibility compliant contrast ratios
 * - Responsive design support
 */

const fs = require('fs');
const path = require('path');

// Standardized Tiation Dark Neon Color Palette
const THEME_COLORS = {
  // Base colors
  background: {
    primary: '#0a0a0a',
    secondary: '#000000',
    card: '#1a1a1a',
    glass: 'rgba(26, 26, 26, 0.9)',
    overlay: 'rgba(0, 0, 0, 0.8)'
  },
  
  // Text colors
  text: {
    primary: '#ffffff',
    secondary: '#b0b0b0',
    muted: '#808080',
    accent: '#e0e0e0'
  },
  
  // Neon accent colors
  neon: {
    cyan: '#00ffff',
    magenta: '#ff00ff',
    electric: '#00ff41',
    purple: '#8000ff',
    blue: '#0080ff'
  },
  
  // Gradients
  gradients: {
    primary: 'linear-gradient(135deg, #00ffff 0%, #0080ff 50%, #8000ff 100%)',
    secondary: 'linear-gradient(45deg, #00ff41 0%, #00ffff 50%, #ff00ff 100%)',
    accent: 'linear-gradient(90deg, #ff00ff 0%, #00ffff 100%)',
    background: 'linear-gradient(180deg, #0a0a0a 0%, #1a1a1a 100%)',
    card: 'linear-gradient(145deg, #1a1a1a 0%, #2a2a2a 100%)'
  },
  
  // Glow effects
  glow: {
    cyan: '0 0 20px rgba(0, 255, 255, 0.5)',
    magenta: '0 0 20px rgba(255, 0, 255, 0.5)',
    electric: '0 0 30px rgba(0, 255, 65, 0.4)',
    soft: '0 0 40px rgba(0, 255, 255, 0.2)',
    intense: '0 0 60px rgba(0, 255, 255, 0.8)'
  }
};

// CSS Variables for consistent theming
const CSS_VARIABLES = `
:root {
  /* Base colors */
  --bg-primary: ${THEME_COLORS.background.primary};
  --bg-secondary: ${THEME_COLORS.background.secondary};
  --bg-card: ${THEME_COLORS.background.card};
  --bg-glass: ${THEME_COLORS.background.glass};
  --bg-overlay: ${THEME_COLORS.background.overlay};
  
  /* Text colors */
  --text-primary: ${THEME_COLORS.text.primary};
  --text-secondary: ${THEME_COLORS.text.secondary};
  --text-muted: ${THEME_COLORS.text.muted};
  --text-accent: ${THEME_COLORS.text.accent};
  
  /* Neon colors */
  --neon-cyan: ${THEME_COLORS.neon.cyan};
  --neon-magenta: ${THEME_COLORS.neon.magenta};
  --neon-electric: ${THEME_COLORS.neon.electric};
  --neon-purple: ${THEME_COLORS.neon.purple};
  --neon-blue: ${THEME_COLORS.neon.blue};
  
  /* Gradients */
  --gradient-primary: ${THEME_COLORS.gradients.primary};
  --gradient-secondary: ${THEME_COLORS.gradients.secondary};
  --gradient-accent: ${THEME_COLORS.gradients.accent};
  --gradient-background: ${THEME_COLORS.gradients.background};
  --gradient-card: ${THEME_COLORS.gradients.card};
  
  /* Glow effects */
  --glow-cyan: ${THEME_COLORS.glow.cyan};
  --glow-magenta: ${THEME_COLORS.glow.magenta};
  --glow-electric: ${THEME_COLORS.glow.electric};
  --glow-soft: ${THEME_COLORS.glow.soft};
  --glow-intense: ${THEME_COLORS.glow.intense};
}
`;

// GitHub Pages Jekyll Theme
const GITHUB_PAGES_THEME = `
${CSS_VARIABLES}

/* Tiation Dark Neon Theme for GitHub Pages */
body {
  background: var(--bg-primary);
  color: var(--text-primary);
  font-family: 'SF Pro Display', 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  overflow-x: hidden;
}

/* Animated background with neon gradients */
body::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: 
    radial-gradient(circle at 20% 20%, rgba(0, 255, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(255, 0, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 60% 40%, rgba(0, 255, 65, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 40% 80%, rgba(128, 0, 255, 0.1) 0%, transparent 50%);
  animation: neon-pulse 8s ease-in-out infinite alternate;
  z-index: -1;
}

@keyframes neon-pulse {
  0% { 
    opacity: 0.3;
    transform: scale(1);
  }
  50% {
    opacity: 0.7;
    transform: scale(1.05);
  }
  100% { 
    opacity: 0.4;
    transform: scale(0.95);
  }
}

/* Header with neon styling */
.site-header {
  background: var(--bg-secondary);
  border-bottom: 2px solid var(--neon-cyan);
  box-shadow: var(--glow-cyan);
  backdrop-filter: blur(10px);
}

.site-title {
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 700;
  font-size: 2rem;
  text-decoration: none;
  transition: all 0.3s ease;
}

.site-title:hover {
  animation: title-glow 1s ease-in-out infinite alternate;
  transform: scale(1.05);
}

@keyframes title-glow {
  from { 
    filter: brightness(1) saturate(1);
    text-shadow: var(--glow-cyan);
  }
  to { 
    filter: brightness(1.3) saturate(1.2);
    text-shadow: var(--glow-intense);
  }
}

/* Navigation with smooth transitions */
.site-nav .page-link {
  color: var(--text-primary);
  transition: all 0.3s ease;
  padding: 10px 15px;
  border-radius: 25px;
  position: relative;
  overflow: hidden;
}

.site-nav .page-link::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: var(--gradient-accent);
  transition: left 0.3s ease;
  z-index: -1;
}

.site-nav .page-link:hover::before {
  left: 0;
}

.site-nav .page-link:hover {
  color: var(--bg-primary);
  text-shadow: none;
  transform: translateY(-2px);
}

/* Main content with glass morphism */
.page-content {
  background: var(--bg-glass);
  border-radius: 20px;
  margin: 30px auto;
  padding: 40px;
  max-width: 1200px;
  box-shadow: var(--glow-soft);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(0, 255, 255, 0.2);
}

/* Headings with animated gradients */
h1, h2, h3, h4, h5, h6 {
  background: var(--gradient-secondary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin: 40px 0 20px 0;
  font-weight: 700;
  position: relative;
}

h1 {
  font-size: 3.5rem;
  text-align: center;
  margin-bottom: 50px;
  animation: heading-glow 3s ease-in-out infinite alternate;
}

@keyframes heading-glow {
  0% { 
    filter: brightness(1);
    text-shadow: var(--glow-electric);
  }
  100% { 
    filter: brightness(1.2);
    text-shadow: var(--glow-intense);
  }
}

/* Links with neon hover effects */
a {
  color: var(--neon-cyan);
  text-decoration: none;
  transition: all 0.3s ease;
  position: relative;
}

a::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background: var(--gradient-accent);
  transition: width 0.3s ease;
}

a:hover::after {
  width: 100%;
}

a:hover {
  color: var(--neon-electric);
  text-shadow: var(--glow-cyan);
}

/* Code blocks with neon styling */
pre, code {
  background: var(--bg-secondary);
  border: 1px solid var(--neon-cyan);
  border-radius: 10px;
  color: var(--neon-electric);
  font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Consolas', monospace;
  position: relative;
  overflow: hidden;
}

pre {
  padding: 25px;
  margin: 20px 0;
  box-shadow: inset var(--glow-cyan);
}

pre::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: var(--gradient-primary);
  animation: code-scan 2s linear infinite;
}

@keyframes code-scan {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

/* Enterprise feature cards */
.feature-card {
  background: var(--bg-card);
  border: 2px solid transparent;
  border-radius: 15px;
  padding: 30px;
  margin: 30px 0;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(10px);
}

.feature-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: var(--gradient-primary);
  padding: 2px;
  border-radius: 15px;
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask-composite: subtract;
  z-index: -1;
}

.feature-card:hover {
  transform: translateY(-10px) scale(1.02);
  box-shadow: var(--glow-intense);
}

/* Buttons with neon effects */
.btn, button {
  background: var(--gradient-primary);
  border: none;
  color: var(--bg-primary);
  padding: 15px 30px;
  border-radius: 30px;
  font-weight: 700;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 1px;
  position: relative;
  overflow: hidden;
}

.btn::before, button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.btn:hover::before, button:hover::before {
  left: 100%;
}

.btn:hover, button:hover {
  transform: scale(1.05);
  box-shadow: var(--glow-intense);
}

/* Footer with gradient border */
.site-footer {
  background: var(--bg-secondary);
  border-top: 3px solid;
  border-image: var(--gradient-accent) 1;
  color: var(--text-secondary);
  text-align: center;
  padding: 40px 0;
  margin-top: 60px;
}

/* Enterprise badges */
.enterprise-badge {
  display: inline-block;
  background: var(--gradient-secondary);
  color: var(--bg-primary);
  padding: 8px 20px;
  border-radius: 25px;
  font-size: 0.9rem;
  font-weight: 700;
  text-transform: uppercase;
  margin: 10px 5px;
  animation: badge-pulse 3s ease-in-out infinite alternate;
  box-shadow: var(--glow-electric);
}

@keyframes badge-pulse {
  0% { 
    transform: scale(1);
    box-shadow: var(--glow-electric);
  }
  100% { 
    transform: scale(1.05);
    box-shadow: var(--glow-intense);
  }
}

/* Scrollbar styling */
::-webkit-scrollbar {
  width: 12px;
}

::-webkit-scrollbar-track {
  background: var(--bg-secondary);
}

::-webkit-scrollbar-thumb {
  background: var(--gradient-primary);
  border-radius: 6px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--gradient-accent);
}

/* Responsive design */
@media (max-width: 768px) {
  .page-content {
    margin: 10px;
    padding: 25px;
  }
  
  h1 {
    font-size: 2.5rem;
  }
  
  .site-title {
    font-size: 1.5rem;
  }
}

/* Special effects for enterprise elements */
.tiation-glow {
  animation: tiation-glow 2s ease-in-out infinite alternate;
}

@keyframes tiation-glow {
  0% { 
    box-shadow: var(--glow-cyan);
    filter: brightness(1);
  }
  100% { 
    box-shadow: var(--glow-intense);
    filter: brightness(1.2);
  }
}

/* Loading animations */
.loading-spinner {
  width: 50px;
  height: 50px;
  border: 3px solid var(--bg-card);
  border-top: 3px solid var(--neon-cyan);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
`;

// VS Code Theme
const VSCODE_THEME = {
  name: "Tiation Dark Neon",
  type: "dark",
  colors: {
    "activityBar.background": THEME_COLORS.background.secondary,
    "activityBar.foreground": THEME_COLORS.neon.cyan,
    "activityBarBadge.background": THEME_COLORS.neon.magenta,
    "activityBarBadge.foreground": THEME_COLORS.background.primary,
    "badge.background": THEME_COLORS.neon.cyan,
    "badge.foreground": THEME_COLORS.background.primary,
    "button.background": THEME_COLORS.neon.cyan,
    "button.foreground": THEME_COLORS.background.primary,
    "button.hoverBackground": THEME_COLORS.neon.electric,
    "editor.background": THEME_COLORS.background.primary,
    "editor.foreground": THEME_COLORS.text.primary,
    "editor.lineHighlightBackground": THEME_COLORS.background.card,
    "editor.selectionBackground": THEME_COLORS.neon.cyan + "40",
    "editorCursor.foreground": THEME_COLORS.neon.cyan,
    "editorGroupHeader.tabsBackground": THEME_COLORS.background.secondary,
    "editorIndentGuide.background": THEME_COLORS.background.card,
    "editorIndentGuide.activeBackground": THEME_COLORS.neon.cyan,
    "editorLineNumber.foreground": THEME_COLORS.text.muted,
    "editorLineNumber.activeForeground": THEME_COLORS.neon.cyan,
    "panel.background": THEME_COLORS.background.secondary,
    "panel.border": THEME_COLORS.neon.cyan,
    "panelTitle.activeForeground": THEME_COLORS.neon.cyan,
    "sideBar.background": THEME_COLORS.background.secondary,
    "sideBar.foreground": THEME_COLORS.text.primary,
    "sideBarSectionHeader.background": THEME_COLORS.background.card,
    "sideBarSectionHeader.foreground": THEME_COLORS.neon.cyan,
    "statusBar.background": THEME_COLORS.background.secondary,
    "statusBar.foreground": THEME_COLORS.neon.cyan,
    "statusBarItem.hoverBackground": THEME_COLORS.neon.cyan + "40",
    "tab.activeBackground": THEME_COLORS.background.primary,
    "tab.activeForeground": THEME_COLORS.neon.cyan,
    "tab.inactiveBackground": THEME_COLORS.background.secondary,
    "tab.inactiveForeground": THEME_COLORS.text.secondary,
    "terminal.background": THEME_COLORS.background.primary,
    "terminal.foreground": THEME_COLORS.text.primary,
    "terminal.ansiCyan": THEME_COLORS.neon.cyan,
    "terminal.ansiMagenta": THEME_COLORS.neon.magenta,
    "terminal.ansiGreen": THEME_COLORS.neon.electric,
    "terminal.ansiBlue": THEME_COLORS.neon.blue,
    "titleBar.activeBackground": THEME_COLORS.background.secondary,
    "titleBar.activeForeground": THEME_COLORS.neon.cyan,
    "workbench.colorTheme": "Tiation Dark Neon"
  },
  tokenColors: [
    {
      scope: ["comment", "punctuation.definition.comment"],
      settings: {
        foreground: THEME_COLORS.text.muted,
        fontStyle: "italic"
      }
    },
    {
      scope: ["string", "string.quoted"],
      settings: {
        foreground: THEME_COLORS.neon.electric
      }
    },
    {
      scope: ["keyword", "storage.type", "storage.modifier"],
      settings: {
        foreground: THEME_COLORS.neon.magenta,
        fontStyle: "bold"
      }
    },
    {
      scope: ["entity.name.function", "meta.function-call"],
      settings: {
        foreground: THEME_COLORS.neon.cyan
      }
    },
    {
      scope: ["variable", "parameter"],
      settings: {
        foreground: THEME_COLORS.text.primary
      }
    },
    {
      scope: ["constant.numeric", "constant.language"],
      settings: {
        foreground: THEME_COLORS.neon.purple
      }
    },
    {
      scope: ["entity.name.type", "entity.name.class"],
      settings: {
        foreground: THEME_COLORS.neon.blue,
        fontStyle: "bold"
      }
    }
  ]
};

// Terminal theme (for Warp and other terminals)
const TERMINAL_THEME = {
  name: "Tiation Dark Neon",
  background: THEME_COLORS.background.primary,
  foreground: THEME_COLORS.text.primary,
  cursor: THEME_COLORS.neon.cyan,
  selection: THEME_COLORS.neon.cyan + "40",
  colors: {
    black: THEME_COLORS.background.primary,
    red: "#ff6b6b",
    green: THEME_COLORS.neon.electric,
    yellow: "#ffd93d",
    blue: THEME_COLORS.neon.blue,
    magenta: THEME_COLORS.neon.magenta,
    cyan: THEME_COLORS.neon.cyan,
    white: THEME_COLORS.text.primary,
    brightBlack: THEME_COLORS.background.card,
    brightRed: "#ff8e8e",
    brightGreen: "#6bff6b",
    brightYellow: "#ffeb3b",
    brightBlue: "#42a5f5",
    brightMagenta: "#ff42ff",
    brightCyan: "#42ffff",
    brightWhite: "#ffffff"
  }
};

// Tailwind CSS configuration
const TAILWIND_CONFIG = {
  darkMode: ['class'],
  theme: {
    extend: {
      colors: {
        // Tiation theme colors
        'tiation-bg': {
          primary: THEME_COLORS.background.primary,
          secondary: THEME_COLORS.background.secondary,
          card: THEME_COLORS.background.card,
          glass: THEME_COLORS.background.glass
        },
        'tiation-text': {
          primary: THEME_COLORS.text.primary,
          secondary: THEME_COLORS.text.secondary,
          muted: THEME_COLORS.text.muted,
          accent: THEME_COLORS.text.accent
        },
        'tiation-neon': {
          cyan: THEME_COLORS.neon.cyan,
          magenta: THEME_COLORS.neon.magenta,
          electric: THEME_COLORS.neon.electric,
          purple: THEME_COLORS.neon.purple,
          blue: THEME_COLORS.neon.blue
        }
      },
      backgroundImage: {
        'tiation-gradient-primary': THEME_COLORS.gradients.primary,
        'tiation-gradient-secondary': THEME_COLORS.gradients.secondary,
        'tiation-gradient-accent': THEME_COLORS.gradients.accent
      },
      boxShadow: {
        'tiation-glow-cyan': THEME_COLORS.glow.cyan,
        'tiation-glow-magenta': THEME_COLORS.glow.magenta,
        'tiation-glow-electric': THEME_COLORS.glow.electric,
        'tiation-glow-soft': THEME_COLORS.glow.soft,
        'tiation-glow-intense': THEME_COLORS.glow.intense
      },
      keyframes: {
        'tiation-glow': {
          '0%, 100%': { boxShadow: THEME_COLORS.glow.cyan },
          '50%': { boxShadow: THEME_COLORS.glow.intense }
        },
        'tiation-float': {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-20px)' }
        },
        'tiation-pulse': {
          '0%, 100%': { opacity: '0.3' },
          '50%': { opacity: '0.7' }
        }
      },
      animation: {
        'tiation-glow': 'tiation-glow 2s ease-in-out infinite alternate',
        'tiation-float': 'tiation-float 6s ease-in-out infinite',
        'tiation-pulse': 'tiation-pulse 4s ease-in-out infinite alternate'
      }
    }
  }
};

// Export functions
function generateGitHubPagesTheme() {
  return GITHUB_PAGES_THEME;
}

function generateVSCodeTheme() {
  return JSON.stringify(VSCODE_THEME, null, 2);
}

function generateTerminalTheme() {
  return JSON.stringify(TERMINAL_THEME, null, 2);
}

function generateTailwindConfig() {
  return JSON.stringify(TAILWIND_CONFIG, null, 2);
}

function generateCSSVariables() {
  return CSS_VARIABLES;
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    console.log('🎨 Tiation Dark Neon Theme System');
    console.log('Usage: node tiation-dark-neon-theme-system.js <command>');
    console.log('');
    console.log('Commands:');
    console.log('  github-pages    Generate GitHub Pages theme');
    console.log('  vscode         Generate VS Code theme');
    console.log('  terminal       Generate terminal theme');
    console.log('  tailwind       Generate Tailwind config');
    console.log('  css-vars       Generate CSS variables');
    console.log('  all            Generate all themes');
    process.exit(0);
  }
  
  const command = args[0];
  
  switch (command) {
    case 'github-pages':
      console.log(generateGitHubPagesTheme());
      break;
    case 'vscode':
      console.log(generateVSCodeTheme());
      break;
    case 'terminal':
      console.log(generateTerminalTheme());
      break;
    case 'tailwind':
      console.log(generateTailwindConfig());
      break;
    case 'css-vars':
      console.log(generateCSSVariables());
      break;
    case 'all':
      console.log('🎨 Generating all Tiation Dark Neon themes...\n');
      
      // Write GitHub Pages theme
      fs.writeFileSync('tiation-github-pages-theme.css', generateGitHubPagesTheme());
      console.log('✅ GitHub Pages theme: tiation-github-pages-theme.css');
      
      // Write VS Code theme
      fs.writeFileSync('tiation-vscode-theme.json', generateVSCodeTheme());
      console.log('✅ VS Code theme: tiation-vscode-theme.json');
      
      // Write terminal theme
      fs.writeFileSync('tiation-terminal-theme.json', generateTerminalTheme());
      console.log('✅ Terminal theme: tiation-terminal-theme.json');
      
      // Write Tailwind config
      fs.writeFileSync('tiation-tailwind-config.json', generateTailwindConfig());
      console.log('✅ Tailwind config: tiation-tailwind-config.json');
      
      // Write CSS variables
      fs.writeFileSync('tiation-css-variables.css', generateCSSVariables());
      console.log('✅ CSS variables: tiation-css-variables.css');
      
      console.log('\n🎉 All themes generated successfully!');
      break;
    default:
      console.log(`Unknown command: ${command}`);
      process.exit(1);
  }
}

module.exports = {
  THEME_COLORS,
  generateGitHubPagesTheme,
  generateVSCodeTheme,
  generateTerminalTheme,
  generateTailwindConfig,
  generateCSSVariables
};
