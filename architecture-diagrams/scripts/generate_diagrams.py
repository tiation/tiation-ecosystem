#!/usr/bin/env python3
"""
Enterprise Architecture Diagrams Generator
Professional system visualizations with dark neon theme
"""

import argparse
import os
import sys
from pathlib import Path
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2, ECS, Lambda
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB, CloudFront, Route53
from diagrams.aws.storage import S3
from diagrams.aws.security import IAM
from diagrams.aws.management import Cloudwatch
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL, MongoDB
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.network import Nginx, Traefik
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.container import Docker, K3S
from diagrams.k8s.compute import Pod, Deployment
from diagrams.k8s.network import Service, Ingress
from diagrams.programming.framework import React, Vue, Angular
from diagrams.programming.language import Python, JavaScript, Go, Java

# Dark Neon Theme Configuration
DARK_NEON_THEME = {
    'background': '#0a0a0a',
    'primary': '#00ff88',
    'secondary': '#ff0080',
    'accent': '#00ddff',
    'text': '#ffffff',
    'grid': '#1a1a1a'
}

class ArchitectureDiagramGenerator:
    """Generate enterprise-grade architecture diagrams"""
    
    def __init__(self, output_dir: str = "output", theme: str = "dark-neon"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.theme = theme
        
    def generate_liberation_system(self):
        """Generate Liberation System architecture diagram"""
        with Diagram("Liberation System Architecture", 
                    filename=str(self.output_dir / "liberation-system-architecture"),
                    show=False,
                    direction="TB",
                    graph_attr={
                        "bgcolor": DARK_NEON_THEME['background'],
                        "fontcolor": DARK_NEON_THEME['text'],
                        "fontname": "Roboto",
                        "fontsize": "16",
                        "style": "filled",
                        "fillcolor": DARK_NEON_THEME['background']
                    }):
            
            # Frontend Layer
            with Cluster("Frontend Layer", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                web_ui = React("Web Interface")
                mobile_app = React("Mobile App")
                admin_panel = Vue("Admin Panel")
            
            # API Gateway Layer
            with Cluster("API Gateway", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                api_gateway = Nginx("API Gateway")
                load_balancer = ELB("Load Balancer")
            
            # Microservices Layer
            with Cluster("Microservices", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['accent'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['accent']
                        }):
                user_service = Python("User Service")
                auth_service = Go("Auth Service")
                data_service = Java("Data Service")
                notification_service = Python("Notification Service")
            
            # Data Layer
            with Cluster("Data Layer", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                primary_db = PostgreSQL("Primary Database")
                cache = Redis("Cache Layer")
                document_store = MongoDB("Document Store")
                file_storage = S3("File Storage")
            
            # Monitoring Layer
            with Cluster("Monitoring & Observability", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                monitoring = Prometheus("Metrics Collection")
                visualization = Grafana("Dashboards")
                logging = Cloudwatch("Centralized Logging")
            
            # Define connections with neon-themed edges
            web_ui >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> api_gateway
            mobile_app >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> api_gateway
            admin_panel >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> api_gateway
            
            api_gateway >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> load_balancer
            load_balancer >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> [user_service, auth_service, data_service]
            
            user_service >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> primary_db
            auth_service >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> cache
            data_service >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> document_store
            notification_service >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> file_storage
            
            # Monitoring connections
            [user_service, auth_service, data_service] >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> monitoring
            monitoring >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> visualization

    def generate_tiation_rigger_workspace(self):
        """Generate Tiation Rigger Workspace architecture diagram"""
        with Diagram("Tiation Rigger Workspace Architecture", 
                    filename=str(self.output_dir / "tiation-rigger-workspace-architecture"),
                    show=False,
                    direction="LR",
                    graph_attr={
                        "bgcolor": DARK_NEON_THEME['background'],
                        "fontcolor": DARK_NEON_THEME['text'],
                        "fontname": "Roboto",
                        "fontsize": "16",
                        "style": "filled",
                        "fillcolor": DARK_NEON_THEME['background']
                    }):
            
            # Client Layer
            with Cluster("Client Applications", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                web_client = React("Web Client")
                mobile_client = React("Mobile Client")
                desktop_client = Angular("Desktop Client")
            
            # API Layer
            with Cluster("API Services", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                connect_api = Python("Connect API")
                jobs_api = Go("Jobs API")
                metrics_api = Java("Metrics API")
            
            # Infrastructure Layer
            with Cluster("Container Orchestration", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['accent'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['accent']
                        }):
                k8s_cluster = K3S("Kubernetes Cluster")
                ingress = Ingress("Ingress Controller")
                services = Service("Services")
                pods = Pod("Application Pods")
            
            # Data & Storage
            with Cluster("Data & Storage", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                postgres = PostgreSQL("PostgreSQL")
                redis_cache = Redis("Redis Cache")
                blob_storage = S3("Blob Storage")
            
            # Automation Layer
            with Cluster("Automation Server", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                automation_server = Server("Automation Server")
                workflow_engine = Lambda("Workflow Engine")
                scheduler = Server("Job Scheduler")
            
            # Define connections
            [web_client, mobile_client, desktop_client] >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> ingress
            ingress >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> services
            services >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> pods
            pods >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> [connect_api, jobs_api, metrics_api]
            
            [connect_api, jobs_api, metrics_api] >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> postgres
            [connect_api, jobs_api] >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> redis_cache
            metrics_api >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> blob_storage
            
            automation_server >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> workflow_engine
            workflow_engine >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> scheduler

    def generate_docker_debian_architecture(self):
        """Generate Docker Debian Alternative architecture diagram"""
        with Diagram("Tiation Docker Debian Architecture", 
                    filename=str(self.output_dir / "docker-debian-architecture"),
                    show=False,
                    direction="TB",
                    graph_attr={
                        "bgcolor": DARK_NEON_THEME['background'],
                        "fontcolor": DARK_NEON_THEME['text'],
                        "fontname": "Roboto",
                        "fontsize": "16",
                        "style": "filled",
                        "fillcolor": DARK_NEON_THEME['background']
                    }):
            
            # Management Layer
            with Cluster("Container Management", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                container_engine = Docker("Container Engine")
                registry = Server("Container Registry")
                orchestrator = K3S("Orchestrator")
            
            # Runtime Layer
            with Cluster("Runtime Environment", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                debian_base = Server("Debian Base")
                security_layer = IAM("Security Layer")
                networking = Traefik("Networking")
            
            # Storage Layer
            with Cluster("Storage & Persistence", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['accent'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['accent']
                        }):
                persistent_storage = S3("Persistent Storage")
                config_store = Server("Config Store")
                backup_system = Server("Backup System")
            
            # Monitoring Layer
            with Cluster("Monitoring & Logging", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                metrics = Prometheus("Metrics Collection")
                logs = Server("Log Aggregation")
                alerting = Server("Alerting System")
            
            # Define connections
            container_engine >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> registry
            registry >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> orchestrator
            orchestrator >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> debian_base
            
            debian_base >> Edge(color=DARK_NEON_THEME['secondary'], style="dashed") >> security_layer
            security_layer >> Edge(color=DARK_NEON_THEME['secondary'], style="dashed") >> networking
            
            [debian_base, security_layer] >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> persistent_storage
            networking >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> config_store
            config_store >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> backup_system
            
            [container_engine, orchestrator, debian_base] >> Edge(color=DARK_NEON_THEME['primary'], style="dotted") >> metrics
            metrics >> Edge(color=DARK_NEON_THEME['primary'], style="dotted") >> logs
            logs >> Edge(color=DARK_NEON_THEME['primary'], style="dotted") >> alerting

    def generate_infrastructure_overview(self):
        """Generate overall infrastructure overview diagram"""
        with Diagram("Tiation Infrastructure Overview", 
                    filename=str(self.output_dir / "infrastructure-overview"),
                    show=False,
                    direction="TB",
                    graph_attr={
                        "bgcolor": DARK_NEON_THEME['background'],
                        "fontcolor": DARK_NEON_THEME['text'],
                        "fontname": "Roboto",
                        "fontsize": "16",
                        "style": "filled",
                        "fillcolor": DARK_NEON_THEME['background']
                    }):
            
            # External Layer
            with Cluster("External Services", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                cdn = CloudFront("CDN")
                dns = Route53("DNS")
                external_apis = Server("External APIs")
            
            # Edge Layer
            with Cluster("Edge Layer", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                load_balancer = ELB("Load Balancer")
                api_gateway = Nginx("API Gateway")
                firewall = IAM("Firewall")
            
            # Application Layer
            with Cluster("Application Services", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['accent'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['accent']
                        }):
                web_services = Server("Web Services")
                api_services = Server("API Services")
                background_jobs = Lambda("Background Jobs")
            
            # Data Layer
            with Cluster("Data Services", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['primary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['primary']
                        }):
                databases = PostgreSQL("Databases")
                cache_layer = Redis("Cache Layer")
                message_queue = Server("Message Queue")
            
            # Infrastructure Layer
            with Cluster("Infrastructure", 
                        graph_attr={
                            "bgcolor": DARK_NEON_THEME['grid'],
                            "fontcolor": DARK_NEON_THEME['secondary'],
                            "style": "filled,rounded",
                            "pencolor": DARK_NEON_THEME['secondary']
                        }):
                container_platform = Docker("Container Platform")
                monitoring = Grafana("Monitoring")
                logging = Cloudwatch("Logging")
            
            # Define connections
            dns >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> cdn
            cdn >> Edge(color=DARK_NEON_THEME['primary'], style="bold") >> load_balancer
            load_balancer >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> api_gateway
            api_gateway >> Edge(color=DARK_NEON_THEME['secondary'], style="bold") >> firewall
            
            firewall >> Edge(color=DARK_NEON_THEME['accent'], style="bold") >> [web_services, api_services]
            [web_services, api_services] >> Edge(color=DARK_NEON_THEME['accent'], style="dashed") >> background_jobs
            
            [web_services, api_services, background_jobs] >> Edge(color=DARK_NEON_THEME['primary'], style="dashed") >> databases
            [web_services, api_services] >> Edge(color=DARK_NEON_THEME['primary'], style="dashed") >> cache_layer
            background_jobs >> Edge(color=DARK_NEON_THEME['primary'], style="dashed") >> message_queue
            
            [web_services, api_services, databases] >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> monitoring
            monitoring >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> logging
            container_platform >> Edge(color=DARK_NEON_THEME['secondary'], style="dotted") >> [web_services, api_services]

    def generate_all_diagrams(self):
        """Generate all architecture diagrams"""
        print("🚀 Generating Enterprise Architecture Diagrams...")
        print(f"📁 Output directory: {self.output_dir}")
        print(f"🎨 Theme: {self.theme}")
        
        diagrams = [
            ("Liberation System", self.generate_liberation_system),
            ("Tiation Rigger Workspace", self.generate_tiation_rigger_workspace),
            ("Docker Debian Alternative", self.generate_docker_debian_architecture),
            ("Infrastructure Overview", self.generate_infrastructure_overview),
        ]
        
        for name, generator in diagrams:
            try:
                print(f"📊 Generating {name}...")
                generator()
                print(f"✅ {name} completed")
            except Exception as e:
                print(f"❌ Error generating {name}: {e}")
        
        print("🎉 All diagrams generated successfully!")
        print(f"📁 Check the output directory: {self.output_dir}")

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description="Generate Enterprise Architecture Diagrams",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python generate_diagrams.py                                    # Generate all diagrams
  python generate_diagrams.py --system liberation-system         # Generate specific system
  python generate_diagrams.py --theme dark-neon --output ./out   # Custom theme and output
        """
    )
    
    parser.add_argument(
        "--system", 
        choices=["liberation-system", "tiation-rigger-workspace", "docker-debian", "infrastructure", "all"],
        default="all",
        help="System to generate diagrams for"
    )
    
    parser.add_argument(
        "--theme", 
        choices=["dark-neon", "light", "default"],
        default="dark-neon",
        help="Theme for the diagrams"
    )
    
    parser.add_argument(
        "--output", 
        default="output",
        help="Output directory for generated diagrams"
    )
    
    args = parser.parse_args()
    
    # Create generator instance
    generator = ArchitectureDiagramGenerator(
        output_dir=args.output,
        theme=args.theme
    )
    
    # Generate diagrams based on system selection
    if args.system == "all":
        generator.generate_all_diagrams()
    elif args.system == "liberation-system":
        generator.generate_liberation_system()
    elif args.system == "tiation-rigger-workspace":
        generator.generate_tiation_rigger_workspace()
    elif args.system == "docker-debian":
        generator.generate_docker_debian_architecture()
    elif args.system == "infrastructure":
        generator.generate_infrastructure_overview()

if __name__ == "__main__":
    main()
