#!/usr/bin/env python3
import psutil
import curses
import time
import json
from pathlib import Path
import argparse

class MeshMonitor:
    def __init__(self, config_path):
        self.config_path = Path(config_path)
        self.screen = curses.initscr()
        curses.start_color()
        curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
        curses.init_pair(2, curses.COLOR_RED, curses.COLOR_BLACK)
        curses.init_pair(3, curses.COLOR_YELLOW, curses.COLOR_BLACK)

    def get_mesh_stats(self):
        try:
            with open(self.config_path / 'system_info.json') as f:
                return json.load(f)
        except Exception:
            return {}

    def display(self):
        try:
            while True:
                self.screen.clear()
                
                # System stats
                cpu_percent = psutil.cpu_percent()
                mem = psutil.virtual_memory()
                
                # Mesh stats
                mesh_stats = self.get_mesh_stats()
                
                # Display information
                self.screen.addstr(0, 0, "Mesh Network Monitor", curses.A_BOLD)
                self.screen.addstr(2, 0, f"CPU Usage: {cpu_percent}%")
                self.screen.addstr(3, 0, f"Memory Usage: {mem.percent}%")
                
                if mesh_stats:
                    self.screen.addstr(5, 0, "Mesh Status:", curses.A_BOLD)
                    self.screen.addstr(6, 0, f"Active Nodes: {len(mesh_stats.get('interfaces', {}))}")
                    self.screen.addstr(7, 0, f"Hostname: {mesh_stats.get('hostname', 'N/A')}")
                
                self.screen.refresh()
                time.sleep(1)
                
        except KeyboardInterrupt:
            pass
        finally:
            curses.endwin()

def main():
    parser = argparse.ArgumentParser(description='Monitor mesh network')
    parser.add_argument('--config', default='/Users/Shared/mesh-network/config',
                       help='Path to config directory')
    args = parser.parse_args()
    
    monitor = MeshMonitor(args.config)
    monitor.display()

if __name__ == '__main__':
    main()
