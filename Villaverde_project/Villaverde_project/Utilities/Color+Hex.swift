import SwiftUI

extension Color {
    /// Create a Color from a hex string like "#F7F3ED" or "F7F3ED".
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

/// App palette — warm neutral theme (Option 3 from the Figma prototype)
enum AppColors {
    static let background = Color(hex: "F7F3ED")
    static let cardBackground = Color(hex: "FDFAF6")
    static let primaryAccent = Color(hex: "B08968")   // terracotta-brown
    static let secondaryAccent = Color(hex: "7C9070") // olive green
    static let textPrimary = Color(hex: "463F3A")
    static let textMuted = Color(hex: "9E9589")
    static let boughtMuted = Color(hex: "CFC9BD")
    static let chipBackground = Color(hex: "EDE9E3")
    static let fieldBorder = Color(hex: "E2DAD1")
    static let deleteAccent = Color(hex: "C9856E")

    static let categoryColors: [GroceryCategory: Color] = [
        .produce: Color(hex: "7C9070"),
        .dairy: Color(hex: "A8B5A0"),
        .pantry: Color(hex: "B08968"),
        .meat: Color(hex: "C17B6B"),
        .other: Color(hex: "9E9589")
    ]

    static let categoryBackgrounds: [GroceryCategory: Color] = [
        .produce: Color(hex: "EEF2EC"),
        .dairy: Color(hex: "F0F4EE"),
        .pantry: Color(hex: "F5EDE4"),
        .meat: Color(hex: "F5EDEB"),
        .other: Color(hex: "F0EDE9")
    ]
}
