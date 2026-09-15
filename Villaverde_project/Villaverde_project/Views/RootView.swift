import SwiftUI

/// Controls which top-level screen is shown: Splash → Onboarding (first
/// launch only) → Home. This is the view your App struct should point to.
struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView()
            } else if !hasCompletedOnboarding {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            } else {
                ContentView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    RootView()
}
