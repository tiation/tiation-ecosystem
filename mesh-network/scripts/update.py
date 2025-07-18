#!/usr/bin/env python3
import subprocess
import sys
import json
from pathlib import Path
import logging

class MeshUpdater:
    def __init__(self, mesh_dir):
        self.mesh_dir = Path(mesh_dir)
        self.requirements_file = self.mesh_dir / 'requirements.txt'
        self.venv_path = self.mesh_dir / 'venv'
        
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )

    def update_dependencies(self):
        """Update Python dependencies"""
        try:
            subprocess.run([
                f'{self.venv_path}/bin/pip',
                'install',
                '--upgrade',
                '-r',
                str(self.requirements_file)
            ], check=True)
            logging.info("Dependencies updated successfully")
            return True
        except Exception as e:
            logging.error(f"Failed to update dependencies: {e}")
            return False

    def update_config(self):
        """Update configuration files"""
        try:
            # Backup existing config
            config_path = self.mesh_dir / 'config' / 'default_config.yaml'
            backup_path = config_path.with_suffix('.yaml.bak')
            
            if config_path.exists():
                config_path.rename(backup_path)
            
            # Copy new default config
            shutil.copy(
                self.mesh_dir / 'config' / 'default_config.yaml.new',
                config_path
            )
            
            logging.info("Configuration updated successfully")
            return True
        except Exception as e:
            logging.error(f"Failed to update configuration: {e}")
            return False

def main():
    parser = argparse.ArgumentParser(description='Update mesh network')
    parser.add_argument('--mesh-dir', default='/Users/Shared/mesh-network',
                       help='Mesh network directory')
    args = parser.parse_args()
    
    updater = MeshUpdater(args.mesh_dir)
    
    print("Updating mesh network...")
    deps_updated = updater.update_dependencies()
    config_updated = updater.update_config()
    
    if deps_updated and config_updated:
        print("Update completed successfully")
        sys.exit(0)
    else:
        print("Update failed")
        sys.exit(1)

if __name__ == '__main__':
    main()
