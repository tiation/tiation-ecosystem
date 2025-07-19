import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showLogin = false
    
    let onboardingPages = [
        OnboardingPage(
            icon: "crane.fill",
            title: "Find Your Next Job",
            description: "Discover rigging opportunities across Western Australia's mining and construction sites",
            primaryColor: .cyan,
            secondaryColor: .blue
        ),
        OnboardingPage(
            icon: "location.fill",
            title: "Location-Based Matching",
            description: "Get matched with jobs near you using advanced location intelligence and smart filtering",
            primaryColor: .magenta,
            secondaryColor: .purple
        ),
        OnboardingPage(
            icon: "dollarsign.circle.fill",
            title: "Maximize Your Earnings",
            description: "Track your income, manage payments, and grow your career with enterprise-grade tools",
            primaryColor: .cyan,
            secondaryColor: .magenta
        )
    ]
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Bottom section
                VStack(spacing: 30) {
                    // Custom page indicator
                    HStack(spacing: 12) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? 
                                     LinearGradient(colors: [.cyan, .magenta], startPoint: .leading, endPoint: .trailing) :
                                     LinearGradient(colors: [.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        if currentPage < onboardingPages.count - 1 {
                            // Next button
                            Button {
                                withAnimation(.easeInOut) {
                                    currentPage += 1
                                }
                            } label: {
                                HStack {
                                    Text("Next")
                                        .font(.system(size: 18, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [.cyan, .magenta],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: .cyan.opacity(0.3), radius: 10)
                            }
                            
                            // Skip button
                            Button("Skip") {
                                showLogin = true
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        } else {
                            // Get Started button
                            Button {
                                showLogin = true
                            } label: {
                                HStack {
                                    Text("Get Started")
                                        .font(.system(size: 18, weight: .semibold))
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 18))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [.cyan, .magenta],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: .magenta.opacity(0.4), radius: 15)
                                .scaleEffect(1.02)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let primaryColor: Color
    let secondaryColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon with animation
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.primaryColor.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateIcon ? 1.1 : 0.9)
                    .opacity(animateIcon ? 0.8 : 0.4)
                
                // Icon background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [page.primaryColor.opacity(0.2), page.secondaryColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [page.primaryColor, page.secondaryColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                
                // Icon
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [page.primaryColor, page.secondaryColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            
            // Text content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, page.primaryColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIcon = true
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                animateText = true
            }
        }
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
