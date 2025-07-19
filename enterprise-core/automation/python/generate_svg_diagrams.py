#!/usr/bin/env python3
"""
Tiation SVG Architecture Diagram Generator
Generate enterprise-grade architecture diagrams using SVG (no matplotlib dependency)
"""

import os
import json
from pathlib import Path
from typing import Dict, List, Tuple

# Tiation Dark Neon Theme Colors
COLORS = {
    'primary_dark': '#0A0A0A',
    'cyan_primary': '#00FFFF',
    'neon_pink': '#FF00FF',
    'purple': '#8B5CF6',
    'indigo': '#6366F1',
    'teal': '#14B8A6',
    'blue': '#007FFF',
    'white': '#FFFFFF',
    'gray': '#6B7280',
    'dark_gray': '#1F2937',
    'light_gray': '#E5E7EB'
}

# Repository architecture patterns
REPO_ARCHITECTURES = {
    'tiation-ai-agents': {
        'type': 'mobile_web_platform',
        'components': [
            {'name': 'React Native\nMobile App', 'type': 'frontend', 'pos': (150, 100)},
            {'name': 'Web Dashboard', 'type': 'frontend', 'pos': (450, 100)},
            {'name': 'AI Agent Engine', 'type': 'backend', 'pos': (300, 200)},
            {'name': 'API Gateway', 'type': 'backend', 'pos': (300, 300)},
            {'name': 'PostgreSQL\nDatabase', 'type': 'database', 'pos': (150, 400)},
            {'name': 'Redis Cache', 'type': 'cache', 'pos': (450, 400)},
            {'name': 'ML Models', 'type': 'ml', 'pos': (550, 300)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (3, 4), (3, 5), (2, 6)
        ]
    },
    'tiation-cms': {
        'type': 'headless_cms',
        'components': [
            {'name': 'Admin Dashboard', 'type': 'frontend', 'pos': (150, 100)},
            {'name': 'Content API', 'type': 'api', 'pos': (450, 100)},
            {'name': 'CMS Core', 'type': 'backend', 'pos': (300, 200)},
            {'name': 'Multi-Tenant\nManager', 'type': 'backend', 'pos': (300, 300)},
            {'name': 'PostgreSQL', 'type': 'database', 'pos': (150, 400)},
            {'name': 'CDN', 'type': 'cdn', 'pos': (550, 200)},
            {'name': 'File Storage', 'type': 'storage', 'pos': (450, 400)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (3, 4), (2, 5), (3, 6)
        ]
    },
    'tiation-docker-debian': {
        'type': 'containerization',
        'components': [
            {'name': 'Docker Images', 'type': 'container', 'pos': (300, 100)},
            {'name': 'Debian Base', 'type': 'os', 'pos': (150, 200)},
            {'name': 'Security Layer', 'type': 'security', 'pos': (450, 200)},
            {'name': 'Container Registry', 'type': 'registry', 'pos': (300, 300)},
            {'name': 'Orchestration', 'type': 'orchestration', 'pos': (300, 400)}
        ],
        'connections': [
            (0, 1), (0, 2), (0, 3), (3, 4)
        ]
    },
    'liberation-system': {
        'type': 'economic_platform',
        'components': [
            {'name': 'Truth Network UI', 'type': 'frontend', 'pos': (150, 100)},
            {'name': 'Resource\nDistribution', 'type': 'frontend', 'pos': (450, 100)},
            {'name': 'Economic Engine', 'type': 'backend', 'pos': (300, 200)},
            {'name': 'Mesh Network', 'type': 'network', 'pos': (550, 200)},
            {'name': 'Blockchain Layer', 'type': 'blockchain', 'pos': (300, 300)},
            {'name': 'Data Analytics', 'type': 'analytics', 'pos': (150, 400)},
            {'name': 'Community Pool', 'type': 'storage', 'pos': (450, 400)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (2, 4), (4, 5), (4, 6)
        ]
    },
    'tiation-terminal-workflows': {
        'type': 'automation_platform',
        'components': [
            {'name': 'Terminal Interface', 'type': 'frontend', 'pos': (300, 100)},
            {'name': 'Workflow Engine', 'type': 'backend', 'pos': (300, 200)},
            {'name': 'Script Repository', 'type': 'storage', 'pos': (150, 300)},
            {'name': 'Automation APIs', 'type': 'api', 'pos': (450, 300)},
            {'name': 'Log Database', 'type': 'database', 'pos': (300, 400)}
        ],
        'connections': [
            (0, 1), (1, 2), (1, 3), (1, 4)
        ]
    },
    'tiation-chase-white-rabbit-ngo': {
        'type': 'ngo_platform',
        'components': [
            {'name': 'GriefToDesign\nApp', 'type': 'frontend', 'pos': (150, 100)},
            {'name': 'Community Portal', 'type': 'frontend', 'pos': (450, 100)},
            {'name': 'NGO Management', 'type': 'backend', 'pos': (300, 200)},
            {'name': 'Payment\nProcessing', 'type': 'payment', 'pos': (550, 200)},
            {'name': 'User Database', 'type': 'database', 'pos': (150, 300)},
            {'name': 'Document Storage', 'type': 'storage', 'pos': (450, 300)},
            {'name': 'Analytics Engine', 'type': 'analytics', 'pos': (300, 400)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (2, 4), (2, 5), (2, 6)
        ]
    }
}

# Component type styling
COMPONENT_STYLES = {
    'frontend': {'color': COLORS['cyan_primary'], 'icon': '🖥️'},
    'backend': {'color': COLORS['neon_pink'], 'icon': '⚙️'},
    'database': {'color': COLORS['purple'], 'icon': '🗄️'},
    'api': {'color': COLORS['teal'], 'icon': '🔌'},
    'cache': {'color': COLORS['indigo'], 'icon': '💾'},
    'ml': {'color': COLORS['blue'], 'icon': '🤖'},
    'storage': {'color': COLORS['purple'], 'icon': '📦'},
    'security': {'color': COLORS['neon_pink'], 'icon': '🔒'},
    'network': {'color': COLORS['cyan_primary'], 'icon': '🌐'},
    'blockchain': {'color': COLORS['teal'], 'icon': '⛓️'},
    'analytics': {'color': COLORS['blue'], 'icon': '📊'},
    'payment': {'color': COLORS['cyan_primary'], 'icon': '💳'},
    'container': {'color': COLORS['indigo'], 'icon': '📦'},
    'os': {'color': COLORS['gray'], 'icon': '🐧'},
    'registry': {'color': COLORS['purple'], 'icon': '🏪'},
    'orchestration': {'color': COLORS['neon_pink'], 'icon': '🎭'},
    'cdn': {'color': COLORS['teal'], 'icon': '🌍'}
}

def create_svg_architecture_diagram(repo_name: str, architecture: Dict, output_path: str):
    """Create an SVG architecture diagram for a repository"""
    
    components = architecture['components']
    connections = architecture['connections']
    
    # SVG dimensions
    width = 700
    height = 500
    
    svg_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
    <defs>
        <style>
            .title {{ font-family: 'Arial', sans-serif; font-size: 24px; font-weight: bold; fill: {COLORS['cyan_primary']}; }}
            .subtitle {{ font-family: 'Arial', sans-serif; font-size: 16px; fill: {COLORS['white']}; }}
            .component-text {{ font-family: 'Arial', sans-serif; font-size: 12px; fill: {COLORS['white']}; text-anchor: middle; }}
            .legend-text {{ font-family: 'Arial', sans-serif; font-size: 10px; fill: {COLORS['gray']}; }}
            .glow {{ filter: drop-shadow(0 0 8px currentColor); }}
        </style>
        <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:{COLORS['primary_dark']};stop-opacity:1" />
            <stop offset="100%" style="stop-color:{COLORS['dark_gray']};stop-opacity:1" />
        </linearGradient>
        <linearGradient id="neonGradient" x1="0%" y1="0%" x2="100%" y2="0%">
            <stop offset="0%" style="stop-color:{COLORS['cyan_primary']};stop-opacity:1" />
            <stop offset="100%" style="stop-color:{COLORS['neon_pink']};stop-opacity:1" />
        </linearGradient>
    </defs>
    
    <!-- Background -->
    <rect width="100%" height="100%" fill="url(#bgGradient)"/>
    
    <!-- Title -->
    <text x="{width//2}" y="30" class="title" text-anchor="middle">{repo_name.replace('-', ' ').title()} Architecture</text>
    <text x="{width//2}" y="50" class="subtitle" text-anchor="middle">{architecture['type'].replace('_', ' ').title()}</text>
    
    <!-- Grid background -->
    <defs>
        <pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">
            <path d="M 20 0 L 0 0 0 20" fill="none" stroke="{COLORS['gray']}" stroke-width="0.5" opacity="0.3"/>
        </pattern>
    </defs>
    <rect x="0" y="70" width="{width}" height="{height-140}" fill="url(#grid)" opacity="0.3"/>
    
    <!-- Connections -->
    <g id="connections">
'''
    
    # Draw connections
    for conn in connections:
        start_idx, end_idx = conn
        start_pos = components[start_idx]['pos']
        end_pos = components[end_idx]['pos']
        
        # Adjust positions for SVG coordinate system
        start_x, start_y = start_pos[0], start_pos[1] + 70
        end_x, end_y = end_pos[0], end_pos[1] + 70
        
        svg_content += f'''
        <line x1="{start_x}" y1="{start_y}" x2="{end_x}" y2="{end_y}" 
              stroke="{COLORS['cyan_primary']}" stroke-width="2" opacity="0.7" class="glow"/>
        <circle cx="{(start_x + end_x)//2}" cy="{(start_y + end_y)//2}" r="2" 
                fill="{COLORS['neon_pink']}" opacity="0.8"/>
'''
    
    svg_content += '''
    </g>
    
    <!-- Components -->
    <g id="components">
'''
    
    # Draw components
    for i, comp in enumerate(components):
        x, y = comp['pos']
        y += 70  # Offset for title
        comp_type = comp['type']
        style = COMPONENT_STYLES.get(comp_type, COMPONENT_STYLES['backend'])
        
        svg_content += f'''
        <g class="component">
            <rect x="{x-60}" y="{y-25}" width="120" height="50" rx="8" 
                  fill="{style['color']}" opacity="0.8" stroke="{COLORS['white']}" stroke-width="2" class="glow"/>
            <rect x="{x-58}" y="{y-23}" width="116" height="46" rx="6" 
                  fill="none" stroke="{style['color']}" stroke-width="1" opacity="0.5"/>
            <text x="{x}" y="{y-5}" class="component-text">{style['icon']}</text>
            <text x="{x}" y="{y+8}" class="component-text">{comp['name']}</text>
            <text x="{x}" y="{y+20}" class="component-text" style="font-size: 8px; fill: {COLORS['gray']}">{comp_type}</text>
        </g>
'''
    
    svg_content += '''
    </g>
    
    <!-- Legend -->
    <g id="legend">
        <rect x="10" y="''' + str(height - 80) + '''" width="150" height="70" rx="5" 
              fill="''' + COLORS['dark_gray'] + '''" opacity="0.8" stroke="''' + COLORS['cyan_primary'] + '''" stroke-width="1"/>
        <text x="20" y="''' + str(height - 60) + '''" class="legend-text" style="font-size: 12px; fill: ''' + COLORS['cyan_primary'] + '''">Component Types</text>
'''
    
    # Add legend items
    legend_types = set(comp['type'] for comp in components)
    for i, comp_type in enumerate(sorted(legend_types)):
        if i < 4:  # Limit legend items
            style = COMPONENT_STYLES.get(comp_type, COMPONENT_STYLES['backend'])
            legend_y = height - 45 + i * 12
            svg_content += f'''
        <rect x="20" y="{legend_y-5}" width="8" height="8" rx="2" fill="{style['color']}" opacity="0.8"/>
        <text x="32" y="{legend_y+2}" class="legend-text">{comp_type.replace('_', ' ').title()}</text>
'''
    
    svg_content += '''
    </g>
    
    <!-- Footer -->
    <text x="''' + str(width - 10) + '''" y="''' + str(height - 10) + '''" class="legend-text" text-anchor="end">
        Built with ❤️ by Tiation | Enterprise Architecture
    </text>
</svg>'''
    
    # Write SVG file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(svg_content)
    
    print(f"✅ Created SVG architecture diagram: {output_path}")

def create_png_from_svg(svg_path: str, png_path: str):
    """Convert SVG to PNG using HTML canvas (creates an HTML file that can be used to generate PNG)"""
    
    html_content = f'''<!DOCTYPE html>
<html>
<head>
    <title>SVG to PNG Converter</title>
    <style>
        body {{
            margin: 0;
            padding: 20px;
            background: #0A0A0A;
            color: white;
            font-family: Arial, sans-serif;
        }}
        .container {{
            text-align: center;
        }}
        svg {{
            border: 1px solid #333;
            background: #0A0A0A;
        }}
        .instructions {{
            margin: 20px 0;
            padding: 20px;
            background: #1F2937;
            border-radius: 8px;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>Architecture Diagram</h1>
        <div class="instructions">
            <h3>Instructions to create PNG:</h3>
            <p>1. Open this HTML file in your browser</p>
            <p>2. Right-click on the SVG diagram below</p>
            <p>3. Select "Save image as..." or "Copy image"</p>
            <p>4. Save as PNG with filename: {png_path.split('/')[-1]}</p>
        </div>
'''
    
    # Read SVG content
    with open(svg_path, 'r', encoding='utf-8') as f:
        svg_content = f.read()
    
    html_content += f'''
        {svg_content}
    </div>
</body>
</html>'''
    
    # Write HTML file
    html_path = svg_path.replace('.svg', '.html')
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"✅ Created HTML converter: {html_path}")
    print(f"   Open in browser to save as PNG: {png_path}")

def generate_all_diagrams():
    """Generate architecture diagrams for all repositories"""
    
    base_path = Path("/Users/tiaastor/tiation-github")
    
    for repo_name, architecture in REPO_ARCHITECTURES.items():
        repo_path = base_path / repo_name
        
        if repo_path.exists():
            print(f"🔮 Creating diagrams for {repo_name}...")
            
            # Create .screenshots directory if it doesn't exist
            screenshots_dir = repo_path / ".screenshots"
            screenshots_dir.mkdir(exist_ok=True)
            
            # Generate SVG architecture diagram
            svg_output_path = screenshots_dir / "architecture-diagram.svg"
            create_svg_architecture_diagram(repo_name, architecture, str(svg_output_path))
            
            # Create HTML converter for PNG generation
            png_output_path = screenshots_dir / "architecture-diagram.png"
            create_png_from_svg(str(svg_output_path), str(png_output_path))
            
        else:
            print(f"⚠️  Repository {repo_name} not found at {repo_path}")

if __name__ == "__main__":
    print("🔮 Tiation SVG Architecture Diagram Generator")
    print("Generating enterprise-grade architecture diagrams using SVG...")
    
    try:
        generate_all_diagrams()
        print("\n✅ All architecture diagrams generated successfully!")
        print("📁 Check the .screenshots/ directory in each repository for:")
        print("   - architecture-diagram.svg (SVG diagram)")
        print("   - architecture-diagram.html (HTML converter)")
        print("\n💡 To create PNG files:")
        print("   1. Open each .html file in your browser")
        print("   2. Right-click on the diagram and save as PNG")
        print("   3. Replace the existing .png files")
    except Exception as e:
        print(f"❌ Error generating diagrams: {e}")
        import traceback
        traceback.print_exc()
