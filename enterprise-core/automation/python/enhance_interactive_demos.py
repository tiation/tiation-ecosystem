#!/usr/bin/env python3
"""
Tiation Interactive Demo Enhancement Script
Create interactive demonstrations and live demos for all Tiation repositories
"""

import os
import json
from pathlib import Path
from typing import Dict, List

# Demo templates for different repository types
DEMO_TEMPLATES = {
    'tiation-ai-agents': {
        'demo_type': 'mobile_web_dashboard',
        'interactive_elements': [
            'AI Agent Chat Interface',
            'Real-time Data Visualization',
            'Mobile App Screenshots Carousel',
            'API Testing Console',
            'Performance Metrics Dashboard'
        ],
        'github_pages_features': [
            'Interactive API Documentation',
            'Live Code Examples',
            'Mobile App Simulator',
            'Real-time Metrics Display'
        ]
    },
    'tiation-cms': {
        'demo_type': 'cms_dashboard',
        'interactive_elements': [
            'Content Management Interface',
            'Multi-tenant Dashboard',
            'API Explorer',
            'Performance Analytics',
            'Revenue Calculator'
        ],
        'github_pages_features': [
            'CMS Demo Interface',
            'Interactive Pricing Calculator',
            'Feature Comparison Table',
            'Customer Success Stories'
        ]
    },
    'liberation-system': {
        'demo_type': 'economic_platform',
        'interactive_elements': [
            'Economic Calculator ($19T Solution)',
            'Resource Distribution Simulator',
            'Truth Network Visualization',
            'Mesh Network Status',
            'Community Impact Metrics'
        ],
        'github_pages_features': [
            'Economic Impact Calculator',
            'Interactive Network Visualization',
            'Real-time Statistics Dashboard',
            'Community Engagement Tools'
        ]
    },
    'tiation-docker-debian': {
        'demo_type': 'container_platform',
        'interactive_elements': [
            'Container Management Interface',
            'Deployment Pipeline Visualization',
            'Security Scan Results',
            'Performance Benchmarks',
            'Enterprise Deployment Guide'
        ],
        'github_pages_features': [
            'Interactive Container Explorer',
            'Live Deployment Simulator',
            'Security Features Demo',
            'Performance Comparison Tools'
        ]
    },
    'tiation-terminal-workflows': {
        'demo_type': 'automation_platform',
        'interactive_elements': [
            'Workflow Builder Interface',
            'Terminal Command Simulator',
            'Automation Scripts Gallery',
            'Performance Metrics',
            'Enterprise Productivity Tools'
        ],
        'github_pages_features': [
            'Interactive Workflow Builder',
            'Live Terminal Simulator',
            'Script Performance Analyzer',
            'Productivity Calculator'
        ]
    },
    'tiation-chase-white-rabbit-ngo': {
        'demo_type': 'ngo_platform',
        'interactive_elements': [
            'GriefToDesign Interface',
            'Impact Measurement Dashboard',
            'Donation Tracking System',
            'Community Engagement Tools',
            'Transparency Reports'
        ],
        'github_pages_features': [
            'Interactive Impact Calculator',
            'Community Stories Gallery',
            'Donation Progress Tracker',
            'Volunteer Management Portal'
        ]
    }
}

def create_interactive_demo_html(repo_name: str, demo_config: Dict) -> str:
    """Create an interactive demo HTML file for a repository"""
    
    demo_type = demo_config['demo_type']
    interactive_elements = demo_config['interactive_elements']
    github_pages_features = demo_config['github_pages_features']
    
    html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{repo_name.replace('-', ' ').title()} - Interactive Demo</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #0A0A0A 0%, #1F2937 100%);
            color: #FFFFFF;
            line-height: 1.6;
            overflow-x: hidden;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }}
        
        .hero {{
            text-align: center;
            padding: 4rem 0;
            background: radial-gradient(circle at center, #00FFFF20 0%, transparent 70%);
            border-radius: 20px;
            margin-bottom: 3rem;
        }}
        
        .hero h1 {{
            font-size: 3rem;
            font-weight: 900;
            background: linear-gradient(135deg, #00FFFF, #FF00FF);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
        }}
        
        .hero p {{
            font-size: 1.2rem;
            color: #E5E7EB;
            margin-bottom: 2rem;
        }}
        
        .demo-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }}
        
        .demo-card {{
            background: rgba(31, 41, 55, 0.8);
            border-radius: 16px;
            padding: 2rem;
            border: 2px solid #374151;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }}
        
        .demo-card:hover {{
            border-color: #00FFFF;
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 255, 255, 0.2);
        }}
        
        .demo-card::before {{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #00FFFF, #FF00FF);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }}
        
        .demo-card:hover::before {{
            transform: scaleX(1);
        }}
        
        .demo-card h3 {{
            color: #00FFFF;
            margin-bottom: 1rem;
            font-size: 1.25rem;
        }}
        
        .demo-card p {{
            color: #D1D5DB;
            margin-bottom: 1rem;
        }}
        
        .demo-button {{
            display: inline-block;
            background: linear-gradient(135deg, #00FFFF, #FF00FF);
            color: #0A0A0A;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }}
        
        .demo-button:hover {{
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 255, 255, 0.3);
        }}
        
        .features-section {{
            background: rgba(139, 92, 246, 0.1);
            border-radius: 16px;
            padding: 3rem;
            margin-bottom: 3rem;
        }}
        
        .features-section h2 {{
            color: #00FFFF;
            margin-bottom: 2rem;
            font-size: 2rem;
            text-align: center;
        }}
        
        .features-list {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }}
        
        .feature-item {{
            background: rgba(255, 255, 255, 0.05);
            padding: 1.5rem;
            border-radius: 12px;
            border: 1px solid rgba(0, 255, 255, 0.2);
        }}
        
        .feature-item h4 {{
            color: #FF00FF;
            margin-bottom: 0.5rem;
        }}
        
        .interactive-demo {{
            background: #1F2937;
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 3rem;
            border: 2px solid #00FFFF;
        }}
        
        .interactive-demo h3 {{
            color: #00FFFF;
            margin-bottom: 1rem;
            text-align: center;
        }}
        
        .demo-simulator {{
            background: #0A0A0A;
            border-radius: 12px;
            padding: 2rem;
            min-height: 400px;
            border: 1px solid #374151;
            position: relative;
            overflow: hidden;
        }}
        
        .demo-simulator::before {{
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 49%, rgba(0, 255, 255, 0.1) 50%, transparent 51%);
            background-size: 20px 20px;
            animation: matrix 20s linear infinite;
        }}
        
        @keyframes matrix {{
            0% {{ background-position: 0 0; }}
            100% {{ background-position: 20px 20px; }}
        }}
        
        .footer {{
            text-align: center;
            padding: 2rem;
            color: #6B7280;
            border-top: 1px solid #374151;
        }}
        
        .footer a {{
            color: #00FFFF;
            text-decoration: none;
        }}
        
        .footer a:hover {{
            text-decoration: underline;
        }}
        
        @media (max-width: 768px) {{
            .hero h1 {{
                font-size: 2rem;
            }}
            
            .demo-grid {{
                grid-template-columns: 1fr;
            }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <header class="hero">
            <h1>{repo_name.replace('-', ' ').title()}</h1>
            <p>Enterprise-grade {demo_type.replace('_', ' ').title()} - Interactive Demo</p>
            <a href="https://github.com/tiaastor/{repo_name}" class="demo-button">
                View on GitHub
            </a>
        </header>
        
        <div class="demo-grid">
"""
    
    # Add interactive elements
    for i, element in enumerate(interactive_elements):
        html_content += f"""
            <div class="demo-card" onclick="openDemo('{element.lower().replace(' ', '_')}')">
                <h3>{element}</h3>
                <p>Interactive demonstration of {element.lower()} with real-time data and enterprise features.</p>
                <span class="demo-button">Launch Demo</span>
            </div>
"""
    
    html_content += """
        </div>
        
        <section class="features-section">
            <h2>Live Features</h2>
            <div class="features-list">
"""
    
    # Add GitHub Pages features
    for feature in github_pages_features:
        html_content += f"""
                <div class="feature-item">
                    <h4>{feature}</h4>
                    <p>Real-time {feature.lower()} with interactive controls and enterprise-grade performance.</p>
                </div>
"""
    
    html_content += f"""
            </div>
        </section>
        
        <section class="interactive-demo">
            <h3>Live Demo Environment</h3>
            <div class="demo-simulator" id="demoSimulator">
                <div style="color: #00FFFF; text-align: center; padding: 2rem;">
                    <h4>🔮 {repo_name.replace('-', ' ').title()} Interactive Demo</h4>
                    <p>Click on any demo card above to launch interactive demonstrations</p>
                    <div style="margin-top: 2rem;">
                        <div style="display: inline-block; margin: 0 1rem;">
                            <div style="color: #FF00FF;">Status:</div>
                            <div id="status">Ready</div>
                        </div>
                        <div style="display: inline-block; margin: 0 1rem;">
                            <div style="color: #FF00FF;">Users:</div>
                            <div id="users">1,337</div>
                        </div>
                        <div style="display: inline-block; margin: 0 1rem;">
                            <div style="color: #FF00FF;">Uptime:</div>
                            <div id="uptime">99.9%</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    
    <footer class="footer">
        <p>Built with ❤️ by <a href="https://github.com/tiaastor">Tiation</a> | 
        <a href="https://github.com/tiaastor/{repo_name}">View Repository</a> | 
        <a href="https://github.com/tiaastor/{repo_name}/wiki">Documentation</a></p>
    </footer>
    
    <script>
        function openDemo(demoType) {{
            const simulator = document.getElementById('demoSimulator');
            const status = document.getElementById('status');
            
            status.textContent = 'Loading ' + demoType.replace('_', ' ') + '...';
            
            setTimeout(() => {{
                simulator.innerHTML = `
                    <div style="color: #00FFFF; text-align: center; padding: 2rem;">
                        <h4>🚀 ${{demoType.replace('_', ' ').toUpperCase()}} Demo</h4>
                        <p>Interactive demonstration of ${{demoType.replace('_', ' ')}} functionality</p>
                        <div style="margin-top: 2rem; background: rgba(0,255,255,0.1); padding: 1rem; border-radius: 8px;">
                            <div style="color: #FF00FF; margin-bottom: 1rem;">Demo Features:</div>
                            <div style="text-align: left; max-width: 400px; margin: 0 auto;">
                                <div>✓ Real-time data visualization</div>
                                <div>✓ Interactive controls</div>
                                <div>✓ Enterprise-grade performance</div>
                                <div>✓ Dark neon theme</div>
                            </div>
                        </div>
                        <button onclick="resetDemo()" style="margin-top: 1rem; background: linear-gradient(135deg, #00FFFF, #FF00FF); color: #0A0A0A; padding: 0.5rem 1rem; border: none; border-radius: 4px; cursor: pointer;">
                            Reset Demo
                        </button>
                    </div>
                `;
                status.textContent = 'Demo Active';
            }}, 1000);
        }}
        
        function resetDemo() {{
            location.reload();
        }}
        
        // Simulate real-time updates
        setInterval(() => {{
            const users = document.getElementById('users');
            if (users) {{
                const currentUsers = parseInt(users.textContent.replace(',', ''));
                const newUsers = currentUsers + Math.floor(Math.random() * 10) - 5;
                users.textContent = Math.max(1000, newUsers).toLocaleString();
            }}
        }}, 5000);
    </script>
</body>
</html>
"""
    
    return html_content

def create_enhanced_readme_section(repo_name: str, demo_config: Dict) -> str:
    """Create an enhanced README section with interactive demo links"""
    
    demo_type = demo_config['demo_type']
    interactive_elements = demo_config['interactive_elements']
    
    readme_section = f"""
## 🎨 Interactive Demos

<div align="center">
  <a href="https://tiaastor.github.io/{repo_name}/demo.html" target="_blank">
    <img src=".screenshots/interactive-demo-preview.png" alt="Interactive Demo Preview" width="80%">
  </a>
  <br>
  <a href="https://tiaastor.github.io/{repo_name}/demo.html" target="_blank">
    <img src="https://img.shields.io/badge/🚀%20Launch%20Interactive%20Demo-00D9FF?style=for-the-badge&logo=github&logoColor=white" alt="Launch Interactive Demo">
  </a>
</div>

### 🔥 Live Features

{chr(10).join(f"- **{element}**: Real-time interactive demonstration with enterprise controls" for element in interactive_elements)}

### 🎯 Demo Highlights

- **Real-time Data Visualization**: Live metrics and performance indicators
- **Interactive Controls**: Hands-on experience with all major features
- **Enterprise Simulation**: Production-grade environment simulation
- **Dark Neon Theme**: Immersive visual experience with gradient effects
- **Mobile Responsive**: Works seamlessly across all devices

---
"""
    
    return readme_section

def generate_demo_enhancements():
    """Generate interactive demo enhancements for all repositories"""
    
    base_path = Path("/Users/tiaastor/tiation-github")
    
    for repo_name, demo_config in DEMO_TEMPLATES.items():
        repo_path = base_path / repo_name
        
        if repo_path.exists():
            print(f"🔮 Enhancing {repo_name}...")
            
            # Create demo.html file
            demo_html = create_interactive_demo_html(repo_name, demo_config)
            demo_file_path = repo_path / "demo.html"
            
            with open(demo_file_path, 'w', encoding='utf-8') as f:
                f.write(demo_html)
            
            print(f"✅ Created interactive demo: {demo_file_path}")
            
            # Create enhanced README section
            readme_section = create_enhanced_readme_section(repo_name, demo_config)
            readme_section_path = repo_path / "INTERACTIVE_DEMO_SECTION.md"
            
            with open(readme_section_path, 'w', encoding='utf-8') as f:
                f.write(readme_section)
            
            print(f"✅ Created README enhancement: {readme_section_path}")
            
            # Create .screenshots directory if it doesn't exist
            screenshots_dir = repo_path / ".screenshots"
            screenshots_dir.mkdir(exist_ok=True)
            
            # Create a placeholder for the interactive demo preview
            demo_preview_path = screenshots_dir / "interactive-demo-preview.png"
            if not demo_preview_path.exists():
                # Create a simple placeholder file
                demo_preview_path.touch()
                print(f"📸 Created demo preview placeholder: {demo_preview_path}")
        else:
            print(f"⚠️  Repository {repo_name} not found at {repo_path}")

def create_github_pages_workflow():
    """Create a GitHub Actions workflow for automated demo deployment"""
    
    workflow_content = """
name: Deploy Interactive Demos

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Build demo
      run: |
        if [ -f "demo.html" ]; then
          echo "Interactive demo found, preparing deployment..."
          mkdir -p build
          cp demo.html build/
          cp -r .screenshots build/ 2>/dev/null || true
          cp -r assets build/ 2>/dev/null || true
        fi
    
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      if: github.ref == 'refs/heads/main'
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./build
        destination_dir: demo
"""
    
    return workflow_content

if __name__ == "__main__":
    print("🔮 Tiation Interactive Demo Enhancement Generator")
    print("Creating interactive demonstrations for all repositories...")
    
    try:
        generate_demo_enhancements()
        print("\n✅ All interactive demos generated successfully!")
        print("📁 Check each repository for:")
        print("   - demo.html (Interactive demo page)")
        print("   - INTERACTIVE_DEMO_SECTION.md (README enhancement)")
        print("   - .screenshots/ directory with placeholder images")
        print("\n💡 Next steps:")
        print("   1. Add the interactive demo section to your README files")
        print("   2. Enable GitHub Pages for each repository")
        print("   3. Test the interactive demos")
        print("   4. Replace placeholder images with actual screenshots")
    except Exception as e:
        print(f"❌ Error generating demos: {e}")
        import traceback
        traceback.print_exc()
