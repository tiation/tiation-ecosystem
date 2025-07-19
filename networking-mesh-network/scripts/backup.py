#!/usr/bin/env python3
import shutil
from pathlib import Path
import datetime
import argparse
import json
import logging

class MeshBackup:
    def __init__(self, mesh_dir, backup_dir):
        self.mesh_dir = Path(mesh_dir)
        self.backup_dir = Path(backup_dir)
        self.backup_dir.mkdir(parents=True, exist_ok=True)
        
        # Setup logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s'
        )

    def create_backup(self):
        """Create a backup of the mesh network configuration"""
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_path = self.backup_dir / f'mesh_backup_{timestamp}'
        
        try:
            # Backup configuration
            shutil.copytree(
                self.mesh_dir / 'config',
                backup_path / 'config'
            )
            
            # Backup logs
            if (self.mesh_dir / 'logs').exists():
                shutil.copytree(
                    self.mesh_dir / 'logs',
                    backup_path / 'logs'
                )
            
            # Create backup info
            backup_info = {
                'timestamp': timestamp,
                'source': str(self.mesh_dir),
                'contents': ['config', 'logs']
            }
            
            with open(backup_path / 'backup_info.json', 'w') as f:
                json.dump(backup_info, f, indent=2)
            
            logging.info(f"Backup created at: {backup_path}")
            return True
            
        except Exception as e:
            logging.error(f"Backup failed: {e}")
            return False

    def restore_backup(self, backup_name):
        """Restore from a backup"""
        backup_path = self.backup_dir / backup_name
        
        if not backup_path.exists():
            logging.error(f"Backup not found: {backup_name}")
            return False
        
        try:
            # Restore configuration
            shutil.rmtree(self.mesh_dir / 'config', ignore_errors=True)
            shutil.copytree(
                backup_path / 'config',
                self.mesh_dir / 'config'
            )
            
            # Restore logs if they exist
            if (backup_path / 'logs').exists():
                shutil.rmtree(self.mesh_dir / 'logs', ignore_errors=True)
                shutil.copytree(
                    backup_path / 'logs',
                    self.mesh_dir / 'logs'
                )
            
            logging.info(f"Restored from backup: {backup_name}")
            return True
            
        except Exception as e:
            logging.error(f"Restore failed: {e}")
            return False

def main():
    parser = argparse.ArgumentParser(description='Mesh network backup utility')
    parser.add_argument('--action', choices=['backup', 'restore'],
                       required=True, help='Action to perform')
    parser.add_argument('--mesh-dir', default='/Users/Shared/mesh-network',
                       help='Mesh network directory')
    parser.add_argument('--backup-dir', default='/Users/Shared/mesh-network/backups',
                       help='Backup directory')
    parser.add_argument('--backup-name', help='Backup name for restore')
    
    args = parser.parse_args()
    
    backup = MeshBackup(args.mesh_dir, args.backup_dir)
    
    if args.action == 'backup':
        backup.create_backup()
    elif args.action == 'restore':
        if not args.backup_name:
            print("Error: --backup-name required for restore")
            sys.exit(1)
        backup.restore_backup(args.backup_name)

if __name__ == '__main__':
    main()
