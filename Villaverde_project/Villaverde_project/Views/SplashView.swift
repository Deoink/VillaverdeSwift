import SwiftUI

/// Screen — shown for a beat on launch, then hands off to Onboarding or Home.
struct SplashView: View {
    @State private var isVisible = false

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppColors.categoryBackgrounds[.produce] ?? AppColors.chipBackground)
                        .frame(width: 96, height: 96)
                    Image(systemName: "basket.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primaryAccent)
                }

                Text("Grocery List")
                    .font(.custom("Georgia", size: 28).weight(.semibold))
                    .foregroundColor(AppColors.textPrimary)

                Text("Shop smarter, spend less")
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.textMuted)
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.9)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    SplashView()
}
