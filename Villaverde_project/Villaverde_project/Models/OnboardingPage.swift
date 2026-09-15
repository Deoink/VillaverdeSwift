import Foundation

/// MODEL — plain data describing one onboarding slide.
struct OnboardingPage: Identifiable {
    let id = UUID()
    let systemImage: String
    let title: String
    let subtitle: String

    static let all: [OnboardingPage] = [
        OnboardingPage(
            systemImage: "list.bullet.rectangle",
            title: "Plan your shopping",
            subtitle: "Organize everything you need to buy by category — produce, dairy, pantry, and more."
        ),
        OnboardingPage(
            systemImage: "tag",
            title: "Track your spending",
            subtitle: "See your estimated total update live as you add items, so you know what you'll spend before you check out."
        ),
        OnboardingPage(
            systemImage: "checkmark.circle",
            title: "Never forget an item",
            subtitle: "Check items off as you shop, and clear your basket in one tap when you're done."
        )
    ]
}
