import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                mainTabView
            } else {
                LoginView()
            }
        }
        .onAppear {
            jobManager.loadJobs()
        }
    }
    
    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            JobsListView()
                .tabItem {
                    Image(systemName: "hammer.circle.fill")
                    Text("Available Jobs")
                }
                .tag(0)
            
            MyJobsView()
                .tabItem {
                    Image(systemName: "briefcase.circle.fill")
                    Text("My Jobs")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(2)
            
            PaymentsView()
                .tabItem {
                    Image(systemName: "creditcard.circle.fill")
                    Text("Payments")
                }
                .tag(3)
        }
        .accentColor(.cyan)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(JobManager())
        .preferredColorScheme(.dark)
}
