import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                TabView(selection: $selectedTab) {
                    JobSearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Find Jobs")
                        }
                        .tag(0)
                    
                    MyApplicationsView()
                        .tabItem {
                            Image(systemName: "doc.text")
                            Text("Applications")
                        }
                        .tag(1)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                        .tag(2)
                    
                    MessagesView()
                        .tabItem {
                            Image(systemName: "message")
                            Text("Messages")
                        }
                        .tag(3)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(4)
                }
                .accentColor(themeManager.primaryColor)
                .background(themeManager.backgroundColor)
            } else {
                AuthenticationView()
            }
        }
        .background(
            LinearGradient(
                colors: [themeManager.backgroundColor, themeManager.secondaryColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationManager())
            .environmentObject(ThemeManager())
    }
}
