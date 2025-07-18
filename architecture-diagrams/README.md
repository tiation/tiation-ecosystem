# 🏗️ Enterprise Architecture Diagrams

> Professional system visualizations for Tiation's enterprise-grade infrastructure

[![Architecture](https://img.shields.io/badge/Architecture-Enterprise%20Grade-00ff88?style=for-the-badge&logo=architecture)](https://github.com/tiaastor)
[![Documentation](https://img.shields.io/badge/Documentation-Professional-ff0080?style=for-the-badge&logo=gitbook)](https://github.com/tiaastor)
[![Diagrams](https://img.shields.io/badge/Diagrams-System%20Visualizations-00ddff?style=for-the-badge&logo=diagram)](https://github.com/tiaastor)

![Architecture Overview](./assets/architecture-hero.png)

## 🚀 About

This repository contains enterprise-grade architecture diagrams for Tiation's infrastructure ecosystem. Each diagram follows professional standards with clear component relationships, data flows, and deployment patterns.

## 🎯 Key Features

- **Professional Documentation** - Enterprise-grade architectural documentation
- **System Visualizations** - Clear component relationships and data flows
- **Deployment Guides** - Production-ready deployment architectures
- **Dark Neon Theme** - Modern, professional visual design
- **Interactive Diagrams** - Clickable components with detailed descriptions

## 📊 Architecture Catalog

### Core Systems
- [Liberation System Architecture](./diagrams/liberation-system/)
- [Tiation Rigger Workspace](./diagrams/tiation-rigger-workspace/)
- [Docker Debian Alternative](./diagrams/tiation-docker-debian/)

### Infrastructure
- [Automation Server](./diagrams/automation-server/)
- [Metrics Dashboard](./diagrams/metrics-dashboard/)
- [VPN Mesh Network](./diagrams/vpn-mesh-network/)

### Applications
- [AI Platform](./diagrams/ai-platform/)
- [Headless CMS](./diagrams/headless-cms/)
- [Mobile Applications](./diagrams/mobile-apps/)

## 🛠️ Diagram Types

### 1. System Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    System Architecture                      │
├─────────────────────────────────────────────────────────────┤
│ • High-level system components                              │
│ • Service boundaries and interfaces                         │
│ • Data flow patterns                                        │
│ • Technology stack visualization                            │
└─────────────────────────────────────────────────────────────┘
```

### 2. Deployment Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                  Deployment Architecture                    │
├─────────────────────────────────────────────────────────────┤
│ • Infrastructure components                                 │
│ • Container orchestration                                   │
│ • Network topology                                          │
│ • Security boundaries                                       │
└─────────────────────────────────────────────────────────────┘
```

### 3. Data Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Data Architecture                        │
├─────────────────────────────────────────────────────────────┤
│ • Data sources and sinks                                    │
│ • Processing pipelines                                      │
│ • Storage strategies                                        │
│ • Data governance                                           │
└─────────────────────────────────────────────────────────────┘
```

## 🎨 Design Standards

### Color Scheme (Dark Neon Theme)
- **Primary**: `#00ff88` (Neon Green)
- **Secondary**: `#ff0080` (Neon Pink)
- **Accent**: `#00ddff` (Neon Cyan)
- **Background**: `#0a0a0a` (Dark)
- **Text**: `#ffffff` (White)

### Typography
- **Headers**: Roboto Bold
- **Body**: Roboto Regular
- **Code**: Fira Code

### Component Styling
- **Rounded corners**: 8px
- **Shadows**: Neon glow effects
- **Lines**: 2px with gradient effects
- **Icons**: Outlined style with neon colors

## 📋 Diagram Standards

### Components
- **Services**: Rounded rectangles with service icons
- **Databases**: Cylinder shapes with database icons
- **APIs**: Hexagonal shapes with API icons
- **Users**: Human figures with role indicators
- **External Systems**: Dashed borders

### Connections
- **Data Flow**: Solid arrows with labels
- **API Calls**: Dashed arrows with HTTP methods
- **Events**: Wavy lines with event names
- **Dependencies**: Dotted lines with dependency types

## 🔧 Tools Used

- **Diagrams as Code**: Python Diagrams library
- **Vector Graphics**: SVG with CSS animations
- **Interactive Elements**: D3.js for clickable components
- **Documentation**: Markdown with Mermaid diagrams
- **Version Control**: Git with semantic versioning

## 🚀 Quick Start

### Prerequisites
```bash
# Install Python dependencies
pip install diagrams graphviz pillow

# Install Node.js dependencies (for interactive features)
npm install d3 mermaid
```

### Generate Diagrams
```bash
# Generate all diagrams
python generate_diagrams.py

# Generate specific system
python generate_diagrams.py --system liberation-system

# Generate with dark theme
python generate_diagrams.py --theme dark-neon
```

### Interactive Viewer
```bash
# Start diagram viewer
npm start

# Open in browser
open http://localhost:3000
```

## 📁 Repository Structure

```
architecture-diagrams/
├── 📁 diagrams/
│   ├── 📁 liberation-system/
│   │   ├── system-architecture.py
│   │   ├── deployment-architecture.py
│   │   └── data-architecture.py
│   ├── 📁 tiation-rigger-workspace/
│   │   ├── microservices-architecture.py
│   │   ├── container-orchestration.py
│   │   └── ci-cd-pipeline.py
│   └── 📁 infrastructure/
│       ├── network-topology.py
│       ├── security-architecture.py
│       └── monitoring-architecture.py
├── 📁 assets/
│   ├── 📁 images/
│   ├── 📁 icons/
│   └── 📁 templates/
├── 📁 scripts/
│   ├── generate_diagrams.py
│   ├── optimize_images.py
│   └── validate_diagrams.py
├── 📁 docs/
│   ├── architecture-guide.md
│   ├── deployment-guide.md
│   └── development-guide.md
└── 📄 README.md
```

## 🔍 Diagram Examples

### System Overview
![System Overview](./assets/examples/system-overview.png)

### Microservices Architecture
![Microservices](./assets/examples/microservices-architecture.png)

### Data Flow
![Data Flow](./assets/examples/data-flow-diagram.png)

## 📚 Documentation

- [Architecture Guide](./docs/architecture-guide.md) - Comprehensive architecture documentation
- [Deployment Guide](./docs/deployment-guide.md) - Production deployment strategies
- [Development Guide](./docs/development-guide.md) - Developer setup and workflows

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch
3. **Follow** the diagram standards
4. **Test** diagram generation
5. **Submit** a pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/tiaastor/architecture-diagrams/issues)
- **Documentation**: [Architecture Docs](./docs/)
- **Examples**: [Diagram Examples](./assets/examples/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <strong>Enterprise Architecture Diagrams</strong><br>
  Professional system visualizations for modern infrastructure
</div>
