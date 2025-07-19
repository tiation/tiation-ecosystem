#!/usr/bin/env python3
"""
Architecture Diagram Generator for Tiation Repositories

This script generates SVG architecture diagrams for each repository
using a consistent dark neon theme that aligns with the Tiation brand.
"""

import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# Architecture definitions for key repositories
ARCHITECTURE_CONFIGS = {
    "tiation-ai-platform": {
        "title": "Tiation AI Platform Architecture",
        "components": [
            ("User Interface", "React/TypeScript Frontend", "#00FFFF"),
            ("API Gateway", "Request Router & Auth", "#FF00FF"),
            ("AI Engine", "ML/NLP Processing", "#00FF88"),
            ("Data Pipeline", "ETL & Analytics", "#FFD700"),
            ("Database", "PostgreSQL & Redis", "#FF4500"),
            ("Infrastructure", "Docker/Kubernetes", "#8A2BE2")
        ],
        "connections": [
            ("User Interface", "API Gateway"),
            ("API Gateway", "AI Engine"),
            ("AI Engine", "Data Pipeline"),
            ("Data Pipeline", "Database"),
            ("API Gateway", "Database"),
            ("Infrastructure", "API Gateway"),
            ("Infrastructure", "AI Engine"),
            ("Infrastructure", "Data Pipeline"),
            ("Infrastructure", "Database")
        ]
    },
    "tiation-ai-agents": {
        "title": "AI Agents Architecture",
        "components": [
            ("Agent Interface", "Web/Mobile Interface", "#00FFFF"),
            ("Agent Core", "Core Agent Logic", "#FF00FF"),
            ("NLP Engine", "Natural Language Processing", "#00FF88"),
            ("Task Manager", "Task Scheduling", "#FFD700"),
            ("Learning System", "ML Training & Inference", "#FF4500"),
            ("Integration Layer", "External APIs", "#8A2BE2")
        ],
        "connections": [
            ("Agent Interface", "Agent Core"),
            ("Agent Core", "NLP Engine"),
            ("Agent Core", "Task Manager"),
            ("Agent Core", "Learning System"),
            ("Agent Core", "Integration Layer"),
            ("Task Manager", "Integration Layer"),
            ("Learning System", "NLP Engine")
        ]
    },
    "tiation-terminal-workflows": {
        "title": "Terminal Workflows Architecture",
        "components": [
            ("Terminal UI", "Interactive Interface", "#00FFFF"),
            ("Workflow Engine", "Execution Engine", "#FF00FF"),
            ("Script Manager", "Script Repository", "#00FF88"),
            ("Configuration", "Settings & Profiles", "#FFD700"),
            ("Integration API", "External Tools", "#FF4500"),
            ("File System", "Local Storage", "#8A2BE2")
        ],
        "connections": [
            ("Terminal UI", "Workflow Engine"),
            ("Workflow Engine", "Script Manager"),
            ("Workflow Engine", "Configuration"),
            ("Workflow Engine", "Integration API"),
            ("Script Manager", "File System"),
            ("Configuration", "File System"),
            ("Integration API", "File System")
        ]
    },
    "tiation-docker-debian": {
        "title": "Docker Debian Architecture",
        "components": [
            ("Base Images", "Debian Base Containers", "#00FFFF"),
            ("Security Layer", "Security Hardening", "#FF00FF"),
            ("Orchestration", "Container Management", "#00FF88"),
            ("Monitoring", "Logging & Metrics", "#FFD700"),
            ("Registry", "Image Repository", "#FF4500"),
            ("Deployment", "Production Deploy", "#8A2BE2")
        ],
        "connections": [
            ("Base Images", "Security Layer"),
            ("Security Layer", "Orchestration"),
            ("Orchestration", "Monitoring"),
            ("Base Images", "Registry"),
            ("Orchestration", "Deployment"),
            ("Monitoring", "Deployment"),
            ("Registry", "Deployment")
        ]
    },
    "tiation-cms": {
        "title": "Headless CMS Architecture",
        "components": [
            ("Admin Dashboard", "Content Management UI", "#00FFFF"),
            ("Content API", "GraphQL/REST API", "#FF00FF"),
            ("Media Manager", "Asset Management", "#00FF88"),
            ("User Management", "Authentication & Authorization", "#FFD700"),
            ("Database", "Content Storage", "#FF4500"),
            ("CDN", "Content Delivery", "#8A2BE2")
        ],
        "connections": [
            ("Admin Dashboard", "Content API"),
            ("Content API", "Media Manager"),
            ("Content API", "User Management"),
            ("Content API", "Database"),
            ("Media Manager", "CDN"),
            ("User Management", "Database"),
            ("Database", "CDN")
        ]
    },
    "DiceRollerSimulator": {
        "title": "Dice Roller Simulator Architecture",
        "components": [
            ("Web Interface", "HTML5/CSS3/JS UI", "#00FFFF"),
            ("Dice Engine", "Random Number Generator", "#FF00FF"),
            ("Game Logic", "Rules & Mechanics", "#00FF88"),
            ("Statistics", "Roll Analytics", "#FFD700"),
            ("Local Storage", "User Preferences", "#FF4500"),
            ("Animation", "Visual Effects", "#8A2BE2")
        ],
        "connections": [
            ("Web Interface", "Dice Engine"),
            ("Dice Engine", "Game Logic"),
            ("Game Logic", "Statistics"),
            ("Web Interface", "Statistics"),
            ("Web Interface", "Local Storage"),
            ("Web Interface", "Animation"),
            ("Dice Engine", "Animation")
        ]
    },
    "tiation-chase-white-rabbit-ngo": {
        "title": "Chase White Rabbit NGO Architecture",
        "components": [
            ("Community Portal", "Public Interface", "#00FFFF"),
            ("Admin Dashboard", "Management Interface", "#FF00FF"),
            ("Event Manager", "Event Coordination", "#00FF88"),
            ("Impact Tracker", "Social Impact Metrics", "#FFD700"),
            ("Volunteer Portal", "Community Engagement", "#FF4500"),
            ("Database", "Data Storage", "#8A2BE2")
        ],
        "connections": [
            ("Community Portal", "Event Manager"),
            ("Admin Dashboard", "Event Manager"),
            ("Event Manager", "Impact Tracker"),
            ("Community Portal", "Volunteer Portal"),
            ("Event Manager", "Database"),
            ("Impact Tracker", "Database"),
            ("Volunteer Portal", "Database")
        ]
    }
}

def generate_svg_architecture(repo_name: str, config: Dict) -> str:
    """Generate an SVG architecture diagram for a repository"""
    
    # SVG dimensions and styling
    width = 1000
    height = 700
    margin = 60
    
    # Calculate component positions
    components = config["components"]
    connections = config["connections"]
    
    # Create a grid layout for components
    cols = 3
    rows = (len(components) + cols - 1) // cols
    
    comp_width = (width - 2 * margin) / cols - 30
    comp_height = (height - 2 * margin - 100) / rows - 30
    
    # Position components
    positions = {}
    for i, (name, desc, color) in enumerate(components):
        row = i // cols
        col = i % cols
        x = margin + col * (comp_width + 30) + comp_width / 2
        y = margin + 80 + row * (comp_height + 30) + comp_height / 2
        positions[name] = (x, y, color)
    
    # Start SVG
    svg = f'''<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <style>
            .component {{
                font-family: 'Courier New', monospace;
                font-size: 14px;
                font-weight: bold;
                text-anchor: middle;
                dominant-baseline: middle;
            }}
            .component-desc {{
                font-family: 'Courier New', monospace;
                font-size: 11px;
                font-weight: normal;
                text-anchor: middle;
                dominant-baseline: middle;
            }}
            .title {{
                font-family: 'Courier New', monospace;
                font-size: 24px;
                font-weight: bold;
                text-anchor: middle;
                fill: #00FFFF;
                filter: drop-shadow(0 0 10px #00FFFF);
            }}
            .subtitle {{
                font-family: 'Courier New', monospace;
                font-size: 14px;
                font-weight: normal;
                text-anchor: middle;
                fill: #FFFFFF;
                opacity: 0.8;
            }}
            .connection {{
                stroke: #00FF88;
                stroke-width: 2;
                stroke-opacity: 0.7;
                marker-end: url(#arrowhead);
                filter: drop-shadow(0 0 3px #00FF88);
            }}
            .glow {{
                filter: drop-shadow(0 0 8px currentColor);
            }}
            .component-box {{
                filter: drop-shadow(0 0 10px currentColor);
            }}
        </style>
        <marker id="arrowhead" markerWidth="12" markerHeight="10" 
                refX="10" refY="5" orient="auto">
            <polygon points="0 0, 12 5, 0 10" fill="#00FF88" />
        </marker>
        <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#0A0A0A;stop-opacity:1" />
            <stop offset="30%" style="stop-color:#1A1A2E;stop-opacity:1" />
            <stop offset="70%" style="stop-color:#16213E;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#0A0A0A;stop-opacity:1" />
        </linearGradient>
        <radialGradient id="centerGlow" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#00FFFF;stop-opacity:0.1" />
            <stop offset="100%" style="stop-color:#FF00FF;stop-opacity:0.05" />
        </radialGradient>
    </defs>
    
    <!-- Background -->
    <rect width="{width}" height="{height}" fill="url(#bg)" />
    <rect width="{width}" height="{height}" fill="url(#centerGlow)" />
    
    <!-- Title -->
    <text x="{width/2}" y="40" class="title">{config["title"]}</text>
    <text x="{width/2}" y="65" class="subtitle">🔮 Tiation Ecosystem • Enterprise Architecture</text>
    
    <!-- Grid lines for visual structure -->
    <defs>
        <pattern id="grid" width="50" height="50" patternUnits="userSpaceOnUse">
            <path d="M 50 0 L 0 0 0 50" fill="none" stroke="#00FFFF" stroke-width="0.5" opacity="0.1"/>
        </pattern>
    </defs>
    <rect width="{width}" height="{height}" fill="url(#grid)" />
    
    <!-- Connections -->
'''
    
    # Draw connections first (so they appear behind components)
    for from_comp, to_comp in connections:
        if from_comp in positions and to_comp in positions:
            x1, y1, _ = positions[from_comp]
            x2, y2, _ = positions[to_comp]
            
            # Calculate control points for curved connections
            mid_x = (x1 + x2) / 2
            mid_y = (y1 + y2) / 2
            
            # Create smooth curved path
            svg += f'''    <path d="M {x1} {y1} Q {mid_x} {mid_y - 20} {x2} {y2}" 
                  class="connection" fill="none" />
'''
    
    # Draw components
    for name, desc, color in components:
        if name in positions:
            x, y, _ = positions[name]
            
            # Component dimensions
            box_width = comp_width * 0.8
            box_height = comp_height * 0.6
            
            svg += f'''    
    <!-- {name} -->
    <g class="component-box">
        <rect x="{x - box_width/2}" y="{y - box_height/2}" 
              width="{box_width}" height="{box_height}" 
              fill="{color}" fill-opacity="0.15" 
              stroke="{color}" stroke-width="2" 
              rx="15" ry="15" />
        <rect x="{x - box_width/2 + 2}" y="{y - box_height/2 + 2}" 
              width="{box_width - 4}" height="{box_height - 4}" 
              fill="none" 
              stroke="{color}" stroke-width="1" stroke-opacity="0.3"
              rx="13" ry="13" />
        <text x="{x}" y="{y - 8}" class="component" fill="{color}">{name}</text>
        <text x="{x}" y="{y + 12}" class="component-desc" fill="#FFFFFF" opacity="0.8">{desc}</text>
    </g>
'''
    
    # Add decorative elements
    svg += f'''
    <!-- Decorative corner elements -->
    <circle cx="30" cy="30" r="3" fill="#00FFFF" opacity="0.5" />
    <circle cx="{width-30}" cy="30" r="3" fill="#FF00FF" opacity="0.5" />
    <circle cx="30" cy="{height-30}" r="3" fill="#00FF88" opacity="0.5" />
    <circle cx="{width-30}" cy="{height-30}" r="3" fill="#FFD700" opacity="0.5" />
    
    <!-- Tiation branding -->
    <text x="30" y="{height-15}" class="component-desc" fill="#00FFFF" text-anchor="start" opacity="0.7">
        Built with 💜 by Tiation • Enterprise-grade Architecture
    </text>
    
    <!-- Version info -->
    <text x="{width-30}" y="{height-15}" class="component-desc" fill="#FFFFFF" text-anchor="end" opacity="0.5">
        v1.0 • {repo_name}
    </text>
    
</svg>'''
    
    return svg

def create_architecture_diagrams():
    """Create architecture diagrams for all configured repositories"""
    base_path = Path("/Users/tiaastor/tiation-github")
    
    print("🏗️ Generating architecture diagrams...")
    
    generated_count = 0
    
    for repo_name, config in ARCHITECTURE_CONFIGS.items():
        repo_path = base_path / repo_name
        
        if not repo_path.exists():
            print(f"❌ Repository {repo_name} not found")
            continue
        
        # Create assets/architecture directory
        arch_dir = repo_path / "assets" / "architecture"
        arch_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate SVG
        svg_content = generate_svg_architecture(repo_name, config)
        
        # Save SVG file
        svg_path = arch_dir / f"{repo_name}-architecture.svg"
        with open(svg_path, 'w', encoding='utf-8') as f:
            f.write(svg_content)
        
        print(f"✅ Generated architecture diagram for {repo_name}")
        generated_count += 1
    
    print(f"\n🎉 Generated {generated_count} architecture diagrams successfully!")

def create_placeholder_screenshots():
    """Create placeholder screenshots for repositories"""
    base_path = Path("/Users/tiaastor/tiation-github")
    
    print("📸 Creating placeholder screenshots...")
    
    # Enhanced SVG placeholder with dark neon theme
    def create_placeholder_svg(repo_name: str, screenshot_type: str) -> str:
        return f'''<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#0A0A0A;stop-opacity:1" />
            <stop offset="30%" style="stop-color:#1A1A2E;stop-opacity:1" />
            <stop offset="70%" style="stop-color:#16213E;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#0A0A0A;stop-opacity:1" />
        </linearGradient>
        <radialGradient id="glow" cx="50%" cy="50%" r="50%">
            <stop offset="0%" style="stop-color:#00FFFF;stop-opacity:0.2" />
            <stop offset="100%" style="stop-color:#FF00FF;stop-opacity:0.1" />
        </radialGradient>
    </defs>
    
    <rect width="800" height="600" fill="url(#bg)" />
    <rect width="800" height="600" fill="url(#glow)" />
    
    <!-- Mock interface elements -->
    <rect x="50" y="50" width="700" height="60" fill="#1A1A2E" stroke="#00FFFF" stroke-width="2" rx="10" />
    <text x="400" y="85" text-anchor="middle" 
          font-family="Courier New, monospace" 
          font-size="18px" font-weight="bold" 
          fill="#00FFFF">
        🔮 {repo_name.replace('-', ' ').title()}
    </text>
    
    <!-- Mock content area -->
    <rect x="50" y="130" width="700" height="400" fill="#16213E" fill-opacity="0.5" stroke="#FF00FF" stroke-width="1" rx="5" />
    
    <!-- Mock navigation -->
    <rect x="70" y="150" width="100" height="30" fill="#00FFFF" fill-opacity="0.3" stroke="#00FFFF" stroke-width="1" rx="5" />
    <rect x="190" y="150" width="100" height="30" fill="#FF00FF" fill-opacity="0.3" stroke="#FF00FF" stroke-width="1" rx="5" />
    <rect x="310" y="150" width="100" height="30" fill="#00FF88" fill-opacity="0.3" stroke="#00FF88" stroke-width="1" rx="5" />
    
    <!-- Mock content blocks -->
    <rect x="70" y="200" width="320" height="80" fill="#00FFFF" fill-opacity="0.1" stroke="#00FFFF" stroke-width="1" rx="5" />
    <rect x="410" y="200" width="320" height="80" fill="#FF00FF" fill-opacity="0.1" stroke="#FF00FF" stroke-width="1" rx="5" />
    <rect x="70" y="300" width="660" height="80" fill="#00FF88" fill-opacity="0.1" stroke="#00FF88" stroke-width="1" rx="5" />
    
    <!-- Center message -->
    <text x="400" y="320" text-anchor="middle" 
          font-family="Courier New, monospace" 
          font-size="24px" font-weight="bold" 
          fill="#FFFFFF">
        {screenshot_type.replace('-', ' ').title()}
    </text>
    
    <text x="400" y="350" text-anchor="middle" 
          font-family="Courier New, monospace" 
          font-size="16px" 
          fill="#00FF88">
        Screenshot Coming Soon
    </text>
    
    <text x="400" y="380" text-anchor="middle" 
          font-family="Courier New, monospace" 
          font-size="12px" 
          fill="#FFFFFF" opacity="0.7">
        Enterprise-grade solution in active development
    </text>
    
    <!-- Footer -->
    <rect x="50" y="550" width="700" height="30" fill="#1A1A2E" stroke="#00FFFF" stroke-width="1" rx="5" />
    <text x="400" y="570" text-anchor="middle" 
          font-family="Courier New, monospace" 
          font-size="12px" 
          fill="#00FFFF">
        Tiation Ecosystem • Professional • Scalable • Mission-Driven
    </text>
</svg>'''
    
    # Create placeholder screenshots for key repositories
    key_repos = list(ARCHITECTURE_CONFIGS.keys())
    
    screenshot_count = 0
    
    for repo_name in key_repos:
        repo_path = base_path / repo_name
        
        if not repo_path.exists():
            continue
        
        # Create screenshots directory
        screenshots_dir = repo_path / "assets" / "screenshots"
        screenshots_dir.mkdir(parents=True, exist_ok=True)
        
        # Create placeholder files
        for screenshot_name in ["main-interface", "dashboard"]:
            svg_path = screenshots_dir / f"{screenshot_name}.svg"
            svg_content = create_placeholder_svg(repo_name, screenshot_name)
            with open(svg_path, 'w', encoding='utf-8') as f:
                f.write(svg_content)
            screenshot_count += 1
        
        print(f"✅ Created placeholder screenshots for {repo_name}")
    
    print(f"\n📸 Created {screenshot_count} placeholder screenshots successfully!")

def main():
    """Main function"""
    print("🎨 Tiation Architecture Diagram & Screenshot Generator")
    print("=" * 60)
    
    # Generate architecture diagrams
    create_architecture_diagrams()
    
    # Create placeholder screenshots
    create_placeholder_screenshots()
    
    print("\n🎯 Architecture and screenshot generation complete!")
    print("🚀 Ready to enhance your repository documentation!")

if __name__ == "__main__":
    main()
