import asyncio
import json
import logging
from pathlib import Path
from .advanced_features import EnhancedMesh

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def initialize_mesh():
    """Initialize mesh with system configuration"""
    try:
        # Load system information
        config_path = Path('config/system_info.json')
        network_path = Path('config/network_scan.json')
        
        if not (config_path.exists() and network_path.exists()):
            logger.error("Configuration files not found. Please run setup.sh first")
            return None
            
        with open(config_path) as f:
            system_info = json.load(f)
            
        with open(network_path) as f:
            network_info = json.load(f)
            
        # Initialize enhanced mesh
        mesh = EnhancedMesh()
        
        # Add this node
        mesh.neural.mesh.nodes[system_info['hostname']] = MeshNode(
            id=system_info['hostname'],
            transmission_power=1.0
        )
        
        logger.info(f"Initialized mesh node: {system_info['hostname']}")
        return mesh
        
    except Exception as e:
        logger.error(f"Initialization error: {e}")
        return None

async def main():
    """Main entry point"""
    mesh = await initialize_mesh()
    if mesh is None:
        return
        
    try:
        logger.info("Starting mesh network...")
        await mesh.run_enhanced()
    except KeyboardInterrupt:
        logger.info("Shutting down mesh network...")
    except Exception as e:
        logger.error(f"Runtime error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
