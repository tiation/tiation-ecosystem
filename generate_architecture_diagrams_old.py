#!/usr/bin/env python3
"""
Tiation Architecture Diagram Generator
Generate enterprise-grade architecture diagrams for all Tiation repositories
"""

import os
import json
from pathlib import Path
from typing import Dict, List, Tuple
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, Rectangle, Circle, Arrow
import numpy as np

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
            {'name': 'React Native Mobile App', 'type': 'frontend', 'pos': (1, 4)},
            {'name': 'Web Dashboard', 'type': 'frontend', 'pos': (3, 4)},
            {'name': 'AI Agent Engine', 'type': 'backend', 'pos': (2, 3)},
            {'name': 'API Gateway', 'type': 'backend', 'pos': (2, 2)},
            {'name': 'PostgreSQL Database', 'type': 'database', 'pos': (1, 1)},
            {'name': 'Redis Cache', 'type': 'cache', 'pos': (3, 1)},
            {'name': 'ML Models', 'type': 'ml', 'pos': (4, 2)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (3, 4), (3, 5), (2, 6)
        ]
    },
    'tiation-cms': {
        'type': 'headless_cms',
        'components': [
            {'name': 'Admin Dashboard', 'type': 'frontend', 'pos': (1, 4)},
            {'name': 'Content API', 'type': 'api', 'pos': (3, 4)},
            {'name': 'CMS Core', 'type': 'backend', 'pos': (2, 3)},
            {'name': 'Multi-Tenant Manager', 'type': 'backend', 'pos': (2, 2)},
            {'name': 'PostgreSQL', 'type': 'database', 'pos': (1, 1)},
            {'name': 'CDN', 'type': 'cdn', 'pos': (4, 3)},
            {'name': 'File Storage', 'type': 'storage', 'pos': (3, 1)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (3, 4), (2, 5), (3, 6)
        ]
    },
    'tiation-docker-debian': {
        'type': 'containerization',
        'components': [
            {'name': 'Docker Images', 'type': 'container', 'pos': (2, 4)},
            {'name': 'Debian Base', 'type': 'os', 'pos': (1, 3)},
            {'name': 'Security Layer', 'type': 'security', 'pos': (3, 3)},
            {'name': 'Container Registry', 'type': 'registry', 'pos': (2, 2)},
            {'name': 'Orchestration', 'type': 'orchestration', 'pos': (2, 1)}
        ],
        'connections': [
            (0, 1), (0, 2), (0, 3), (3, 4)
        ]
    },
    'liberation-system': {
        'type': 'economic_platform',
        'components': [
            {'name': 'Truth Network UI', 'type': 'frontend', 'pos': (1, 4)},
            {'name': 'Resource Distribution', 'type': 'frontend', 'pos': (3, 4)},
            {'name': 'Economic Engine', 'type': 'backend', 'pos': (2, 3)},
            {'name': 'Mesh Network', 'type': 'network', 'pos': (4, 3)},
            {'name': 'Blockchain Layer', 'type': 'blockchain', 'pos': (2, 2)},
            {'name': 'Data Analytics', 'type': 'analytics', 'pos': (1, 1)},
            {'name': 'Community Pool', 'type': 'storage', 'pos': (3, 1)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (2, 4), (4, 5), (4, 6)
        ]
    },
    'tiation-terminal-workflows': {
        'type': 'automation_platform',
        'components': [
            {'name': 'Terminal Interface', 'type': 'frontend', 'pos': (2, 4)},
            {'name': 'Workflow Engine', 'type': 'backend', 'pos': (2, 3)},
            {'name': 'Script Repository', 'type': 'storage', 'pos': (1, 2)},
            {'name': 'Automation APIs', 'type': 'api', 'pos': (3, 2)},
            {'name': 'Log Database', 'type': 'database', 'pos': (2, 1)}
        ],
        'connections': [
            (0, 1), (1, 2), (1, 3), (1, 4)
        ]
    },
    'tiation-chase-white-rabbit-ngo': {
        'type': 'ngo_platform',
        'components': [
            {'name': 'GriefToDesign App', 'type': 'frontend', 'pos': (1, 4)},
            {'name': 'Community Portal', 'type': 'frontend', 'pos': (3, 4)},
            {'name': 'NGO Management', 'type': 'backend', 'pos': (2, 3)},
            {'name': 'Payment Processing', 'type': 'payment', 'pos': (4, 3)},
            {'name': 'User Database', 'type': 'database', 'pos': (1, 2)},
            {'name': 'Document Storage', 'type': 'storage', 'pos': (3, 2)},
            {'name': 'Analytics Engine', 'type': 'analytics', 'pos': (2, 1)}
        ],
        'connections': [
            (0, 2), (1, 2), (2, 3), (2, 4), (2, 5), (2, 6)
        ]
    }
}

# Component type styling
COMPONENT_STYLES = {
    'frontend': {'color': COLORS['cyan_primary'], 'shape': 'round'},
    'backend': {'color': COLORS['neon_pink'], 'shape': 'rect'},
    'database': {'color': COLORS['purple'], 'shape': 'cylinder'},
    'api': {'color': COLORS['teal'], 'shape': 'diamond'},
    'cache': {'color': COLORS['indigo'], 'shape': 'rect'},
    'ml': {'color': COLORS['blue'], 'shape': 'hexagon'},
    'storage': {'color': COLORS['purple'], 'shape': 'rect'},
    'security': {'color': COLORS['neon_pink'], 'shape': 'shield'},
    'network': {'color': COLORS['cyan_primary'], 'shape': 'cloud'},
    'blockchain': {'color': COLORS['teal'], 'shape': 'chain'},
    'analytics': {'color': COLORS['blue'], 'shape': 'chart'},
    'payment': {'color': COLORS['cyan_primary'], 'shape': 'diamond'},
    'container': {'color': COLORS['indigo'], 'shape': 'rect'},
    'os': {'color': COLORS['gray'], 'shape': 'rect'},
    'registry': {'color': COLORS['purple'], 'shape': 'rect'},
    'orchestration': {'color': COLORS['neon_pink'], 'shape': 'rect'},
    'cdn': {'color': COLORS['teal'], 'shape': 'cloud'}
}

def create_architecture_diagram(repo_name: str, architecture: Dict, output_path: str):
    """Create an architecture diagram for a repository"""
    
    # Create figure with dark theme
    fig, ax = plt.subplots(1, 1, figsize=(12, 8))
    fig.patch.set_facecolor(COLORS['primary_dark'])
    ax.set_facecolor(COLORS['primary_dark'])
    
    # Hide axes
    ax.set_xlim(0, 5)
    ax.set_ylim(0, 5)
    ax.axis('off')
    
    # Draw components
    components = architecture['components']
    positions = {}
    
    for i, comp in enumerate(components):
        x, y = comp['pos']
        positions[i] = (x, y)
        
        # Get component style
        comp_type = comp['type']
        style = COMPONENT_STYLES.get(comp_type, COMPONENT_STYLES['backend'])
        
        # Create component box
        if style['shape'] == 'round':
            circle = Circle((x, y), 0.3, facecolor=style['color'], 
                          edgecolor=COLORS['white'], linewidth=2, alpha=0.8)
            ax.add_patch(circle)
        else:
            rect = FancyBboxPatch((x-0.4, y-0.2), 0.8, 0.4, 
                                boxstyle="round,pad=0.05",
                                facecolor=style['color'], 
                                edgecolor=COLORS['white'], 
                                linewidth=2, alpha=0.8)
            ax.add_patch(rect)
        
        # Add component label
        ax.text(x, y-0.6, comp['name'], ha='center', va='center', 
                fontsize=9, color=COLORS['white'], weight='bold',
                bbox=dict(boxstyle="round,pad=0.3", facecolor=COLORS['dark_gray'], 
                         alpha=0.7, edgecolor=style['color']))
    
    # Draw connections
    for conn in architecture['connections']:
        start_idx, end_idx = conn
        start_pos = positions[start_idx]
        end_pos = positions[end_idx]
        
        # Draw arrow
        ax.annotate('', xy=end_pos, xytext=start_pos,
                   arrowprops=dict(arrowstyle='->', color=COLORS['cyan_primary'],
                                 lw=2, alpha=0.7))
    
    # Add title
    title = f"{repo_name.replace('-', ' ').title()} Architecture"
    ax.text(2.5, 4.7, title, ha='center', va='center', 
            fontsize=16, color=COLORS['cyan_primary'], weight='bold')
    
    # Add legend for component types
    legend_y = 0.3
    legend_types = set(comp['type'] for comp in components)
    for i, comp_type in enumerate(sorted(legend_types)):
        style = COMPONENT_STYLES.get(comp_type, COMPONENT_STYLES['backend'])
        ax.text(0.2 + (i % 3) * 1.5, legend_y - (i // 3) * 0.15, 
                comp_type.replace('_', ' ').title(),
                ha='left', va='center', fontsize=8, color=style['color'],
                bbox=dict(boxstyle="round,pad=0.2", facecolor=COLORS['dark_gray'], 
                         alpha=0.5, edgecolor=style['color']))
    
    # Save the diagram
    plt.tight_layout()
    plt.savefig(output_path, dpi=300, bbox_inches='tight', 
                facecolor=COLORS['primary_dark'], edgecolor='none')
    plt.close()
    
    print(f"✅ Created architecture diagram: {output_path}")

def generate_all_diagrams():
    """Generate architecture diagrams for all repositories"""
    
    base_path = Path("/Users/tiaastor/tiation-github")
    
    for repo_name, architecture in REPO_ARCHITECTURES.items():
        repo_path = base_path / repo_name
        
        if repo_path.exists():
            # Create .screenshots directory if it doesn't exist
            screenshots_dir = repo_path / ".screenshots"
            screenshots_dir.mkdir(exist_ok=True)
            
            # Generate architecture diagram
            output_path = screenshots_dir / "architecture-diagram.png"
            create_architecture_diagram(repo_name, architecture, str(output_path))
            
            # Also create an enhanced version with more details
            enhanced_output_path = screenshots_dir / "system-architecture.png"
            create_enhanced_architecture_diagram(repo_name, architecture, str(enhanced_output_path))
        else:
            print(f"⚠️  Repository {repo_name} not found at {repo_path}")

def create_enhanced_architecture_diagram(repo_name: str, architecture: Dict, output_path: str):
    """Create an enhanced architecture diagram with more technical details"""
    
    # Create figure with larger size for more details
    fig, ax = plt.subplots(1, 1, figsize=(16, 12))
    fig.patch.set_facecolor(COLORS['primary_dark'])
    ax.set_facecolor(COLORS['primary_dark'])
    
    # Hide axes
    ax.set_xlim(0, 8)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    # Draw components with enhanced styling
    components = architecture['components']
    positions = {}
    
    for i, comp in enumerate(components):
        x, y = comp['pos']
        # Scale positions for larger canvas
        x = x * 1.5 + 1
        y = y * 1.5 + 1
        positions[i] = (x, y)
        
        # Get component style
        comp_type = comp['type']
        style = COMPONENT_STYLES.get(comp_type, COMPONENT_STYLES['backend'])
        
        # Create enhanced component box with gradient effect
        rect = FancyBboxPatch((x-0.6, y-0.4), 1.2, 0.8, 
                            boxstyle="round,pad=0.1",
                            facecolor=style['color'], 
                            edgecolor=COLORS['white'], 
                            linewidth=3, alpha=0.9)
        ax.add_patch(rect)
        
        # Add inner glow effect
        inner_rect = FancyBboxPatch((x-0.55, y-0.35), 1.1, 0.7, 
                                  boxstyle="round,pad=0.05",
                                  facecolor='none', 
                                  edgecolor=style['color'], 
                                  linewidth=1, alpha=0.5)
        ax.add_patch(inner_rect)
        
        # Add component label with enhanced styling
        ax.text(x, y, comp['name'], ha='center', va='center', 
                fontsize=10, color=COLORS['white'], weight='bold')
        
        # Add component type badge
        ax.text(x, y-0.8, comp_type.replace('_', ' ').title(), 
                ha='center', va='center', 
                fontsize=8, color=COLORS['white'], style='italic',
                bbox=dict(boxstyle="round,pad=0.2", facecolor=COLORS['dark_gray'], 
                         alpha=0.8, edgecolor=style['color']))
    
    # Draw enhanced connections with data flow indicators
    for conn in architecture['connections']:
        start_idx, end_idx = conn
        start_pos = positions[start_idx]
        end_pos = positions[end_idx]
        
        # Draw main arrow
        ax.annotate('', xy=end_pos, xytext=start_pos,
                   arrowprops=dict(arrowstyle='->', color=COLORS['cyan_primary'],
                                 lw=3, alpha=0.8))
        
        # Add data flow indicator
        mid_x = (start_pos[0] + end_pos[0]) / 2
        mid_y = (start_pos[1] + end_pos[1]) / 2
        ax.plot(mid_x, mid_y, 'o', color=COLORS['neon_pink'], markersize=4, alpha=0.7)
    
    # Add enhanced title with subtitle
    title = f"{repo_name.replace('-', ' ').title()}"
    subtitle = f"Enterprise Architecture - {architecture['type'].replace('_', ' ').title()}"
    
    ax.text(4, 7.5, title, ha='center', va='center', 
            fontsize=20, color=COLORS['cyan_primary'], weight='bold')
    ax.text(4, 7.2, subtitle, ha='center', va='center', 
            fontsize=14, color=COLORS['white'], style='italic')
    
    # Add architectural layers
    layers = ['Presentation Layer', 'Business Logic Layer', 'Data Layer', 'Infrastructure Layer']
    for i, layer in enumerate(layers):
        y_pos = 6 - i * 1.5
        ax.axhline(y=y_pos, color=COLORS['gray'], linestyle='--', alpha=0.3, linewidth=1)
        ax.text(0.2, y_pos + 0.1, layer, ha='left', va='bottom', 
                fontsize=9, color=COLORS['gray'], style='italic')
    
    # Add technology stack info
    ax.text(7, 1, "Technology Stack:", ha='left', va='top', 
            fontsize=10, color=COLORS['cyan_primary'], weight='bold')
    
    tech_stack = get_tech_stack_for_repo(repo_name)
    for i, tech in enumerate(tech_stack):
        ax.text(7, 0.7 - i * 0.2, f"• {tech}", ha='left', va='top', 
                fontsize=8, color=COLORS['white'])
    
    # Save the enhanced diagram
    plt.tight_layout()
    plt.savefig(output_path, dpi=300, bbox_inches='tight', 
                facecolor=COLORS['primary_dark'], edgecolor='none')
    plt.close()
    
    print(f"✅ Created enhanced architecture diagram: {output_path}")

def get_tech_stack_for_repo(repo_name: str) -> List[str]:
    """Get technology stack for a repository"""
    
    tech_stacks = {
        'tiation-ai-agents': ['React Native', 'Node.js', 'PostgreSQL', 'Redis', 'Docker'],
        'tiation-cms': ['React', 'Node.js', 'PostgreSQL', 'Redis', 'Docker'],
        'tiation-docker-debian': ['Docker', 'Debian', 'Kubernetes', 'Shell Scripts'],
        'liberation-system': ['React', 'TypeScript', 'Node.js', 'Blockchain', 'WebRTC'],
        'tiation-terminal-workflows': ['Bash', 'Python', 'Node.js', 'Shell Scripts'],
        'tiation-chase-white-rabbit-ngo': ['Vue.js', 'Node.js', 'PostgreSQL', 'Stripe API']
    }
    
    return tech_stacks.get(repo_name, ['Web Technologies', 'Backend Services', 'Database'])

if __name__ == "__main__":
    print("🔮 Tiation Architecture Diagram Generator")
    print("Generating enterprise-grade architecture diagrams...")
    
    try:
        generate_all_diagrams()
        print("\n✅ All architecture diagrams generated successfully!")
        print("📁 Check the .screenshots/ directory in each repository")
    except Exception as e:
        print(f"❌ Error generating diagrams: {e}")
        print("💡 Make sure you have matplotlib installed: pip install matplotlib")
