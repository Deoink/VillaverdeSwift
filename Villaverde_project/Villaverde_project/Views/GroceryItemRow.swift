import SwiftUI

/// Reusable component (not a full screen) — a single row card used inside
/// HomeView's List. Tapping the row (outside the checkbox) is handled by
/// the parent, which wraps this in a Button for navigation to ItemDetailView.
struct GroceryItemRow: View {
    let item: GroceryItem
    let onToggle: () -> Void

    var body: some View {
        Group {
            HStack(spacing: 12) {
                // Checkbox
                Button(action: onToggle) {
                    ZStack {
                        Circle()
                            .strokeBorder(item.bought ? AppColors.primaryAccent : AppColors.boughtMuted, lineWidth: 2)
                            .background(Circle().fill(item.bought ? AppColors.primaryAccent : Color.clear))
                            .frame(width: 24, height: 24)
                        if item.bought {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(.borderless) // keeps this tap target independent of the row's NavigationLink

                // Name + price
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(item.bought ? AppColors.boughtMuted : AppColors.textPrimary)
                        .strikethrough(item.bought, color: AppColors.boughtMuted)
                        .lineLimit(1)

                    if item.price > 0 {
                        Text("₱\(item.price, specifier: "%.0f") × \(item.quantity) = ₱\(item.lineTotal, specifier: "%.0f")")
                            .font(.system(size: 11))
                            .foregroundColor(item.bought ? AppColors.boughtMuted : AppColors.textMuted)
                    }
                }

                Spacer()

                // Qty pill
                Text("×\(item.quantity)")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        Capsule().fill(item.bought ? AppColors.chipBackground : (AppColors.categoryBackgrounds[item.category] ?? AppColors.chipBackground))
                    )
                    .foregroundColor(item.bought ? AppColors.boughtMuted : (AppColors.categoryColors[item.category] ?? AppColors.textMuted))

                // Category dot
                Circle()
                    .fill(item.bought ? AppColors.boughtMuted : (AppColors.categoryColors[item.category] ?? AppColors.textMuted))
                    .frame(width: 8, height: 8)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(item.bought ? Color(hex: "F5F1EC") : AppColors.cardBackground)
            )
            .opacity(item.bought ? 0.72 : 1)
            .shadow(color: AppColors.textPrimary.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .contentShape(Rectangle())
    }
}
