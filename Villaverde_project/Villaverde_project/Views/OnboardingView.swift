import SwiftUI

/// Screen — 3-page swipeable "Get Started" onboarding, shown once before Home.
struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var currentPage = 0
    private let pages = OnboardingPage.all

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") { onFinish() }
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColors.textMuted)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .frame(height: 30)

                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        pageView(page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? AppColors.primaryAccent : AppColors.chipBackground)
                            .frame(width: index == currentPage ? 20 : 8, height: 8)
                            .animation(.easeOut(duration: 0.2), value: currentPage)
                    }
                }
                .padding(.bottom, 24)

                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        onFinish()
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(AppColors.primaryAccent))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppColors.categoryBackgrounds[.produce] ?? AppColors.chipBackground)
                    .frame(width: 140, height: 140)
                Image(systemName: page.systemImage)
                    .font(.system(size: 56))
                    .foregroundColor(AppColors.primaryAccent)
            }

            VStack(spacing: 10) {
                Text(page.title)
                    .font(.custom("Georgia", size: 22).weight(.semibold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
