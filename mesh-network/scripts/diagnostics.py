#!/usr/bin/env python3
import subprocess
import netifaces
import socket
import json
import sys
from pathlib import Path

class MeshDiagnostics:
    def __init__(self):
        self.results = {
            'network': {},
            'connectivity': {},
            'performance': {}
        }

    def check_interfaces(self):
        """Check network interfaces"""
        for interface in netifaces.interfaces():
            try:
                addrs = netifaces.ifaddresses(interface)
                if netifaces.AF_INET in addrs:
                    self.results['network'][interface] = {
                        'ip': addrs[netifaces.AF_INET][0]['addr'],
                        'status': 'active'
                    }
            except Exception as e:
                self.results['network'][interface] = {
                    'status': 'error',
                    'error': str(e)
                }

    def check_connectivity(self):
        """Test network connectivity"""
        hosts = ['8.8.8.8', '1.1.1.1']
        for host in hosts:
            try:
                subprocess.run(['ping', '-c', '1', host],
                             capture_output=True, check=True)
                self.results['connectivity'][host] = 'reachable'
            except subprocess.CalledProcessError:
                self.results['connectivity'][host] = 'unreachable'

    def check_performance(self):
        """Test network performance"""
        try:
            # Simple speed test
            result = subprocess.run(['speedtest-cli', '--json'],
                                  capture_output=True, text=True)
            self.results['performance'] = json.loads(result.stdout)
        except Exception as e:
            self.results['performance']['error'] = str(e)

    def run_diagnostics(self):
        """Run all diagnostic checks"""
        print("Running mesh network diagnostics...")
        
        print("Checking interfaces...")
        self.check_interfaces()
        
        print("Testing connectivity...")
        self.check_connectivity()
        
        print("Testing performance...")
        self.check_performance()
        
        return self.results

def main():
    diagnostics = MeshDiagnostics()
    results = diagnostics.run_diagnostics()
    
    output_file = Path('/Users/Shared/mesh-network/logs/diagnostics.json')
    output_file.parent.mkdir(exist_ok=True)
    
    with open(output_file, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"\nDiagnostics complete. Results saved to {output_file}")
    
    # Print summary
    print("\nSummary:")
    print("-" * 40)
    print(f"Interfaces checked: {len(results['network'])}")
    print(f"Connectivity tests: {len(results['connectivity'])}")
    if 'error' not in results['performance']:
        print(f"Network speed: {results['performance'].get('download', 'N/A')} Mbps")

if __name__ == '__main__':
    main()
