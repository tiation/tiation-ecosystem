//
//  TiationShellApp.swift
//  TiationShell
//
//  Created by Tiation on 2025-01-16.
//  Copyright © 2025 Tiation. All rights reserved.
//

import SwiftUI

@main
struct TiationShellApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Initialize core services
        ServerManager.shared.initialize()
        FileSystemManager.shared.initialize()
        SSHConnectionManager.shared.initialize()
        
        print("🚀 TiationShell iOS App Started")
    }
}
