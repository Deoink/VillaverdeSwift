import SwiftUI
import Combine

/// Screen 2 of 4 — shown after tapping an item on Home.
struct ItemDetailView: View {
    let item: GroceryItem
    @ObservedObject var controller: GroceryListController
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Circle()
                        .fill(AppColors.categoryBackgrounds[item.category] ?? AppColors.chipBackground)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "basket.fill")
                                .foregroundColor(AppColors.categoryColors[item.category] ?? AppColors.textMuted)
                        )

                    Text(item.name)
                        .font(.custom("Georgia", size: 22).weight(.semibold))
                        .foregroundColor(AppColors.textPrimary)

                    Text(item.category.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(AppColors.categoryBackgrounds[item.category] ?? AppColors.chipBackground))
                        .foregroundColor(AppColors.categoryColors[item.category] ?? AppColors.textMuted)
                }
                .padding(.top, 24)

                VStack(spacing: 0) {
                    detailRow(label: "Quantity", value: "\(item.quantity)")
                    Divider()
                    detailRow(label: "Price", value: "₱\(String(format: "%.0f", item.price))")
                    Divider()
                    detailRow(label: "Line total", value: "₱\(String(format: "%.0f", item.lineTotal))")
                    Divider()
                    detailRow(label: "Status", value: item.bought ? "In the basket ✓" : "Still needed")
                }
                .background(RoundedRectangle(cornerRadius: 18).fill(AppColors.cardBackground))
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        path.append(Route.addEditItem(item))
                    } label: {
                        Text("Edit item")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().fill(AppColors.primaryAccent))
                    }

                    Button(role: .destructive) {
                        controller.deleteItem(item)
                        path.removeLast()
                    } label: {
                        Text("Delete item")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppColors.deleteAccent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Capsule().stroke(AppColors.deleteAccent, lineWidth: 1.5))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Item Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(AppColors.textMuted)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
