import SwiftUI
import UserNotifications

@main
struct RiggerHireApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var jobManager = JobManager()
    
    init() {
        configureAppearance()
        requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(jobManager)
                .preferredColorScheme(.dark)
        }
    }
    
    private func configureAppearance() {
        // Configure dark neon theme
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.systemCyan
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        UITabBar.appearance().tintColor = UIColor.systemCyan
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemGray
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
}
