import SwiftUI
import Combine

/// Screen 4 of 4 — spend breakdown, reached from the chart icon on Home.
struct SummaryView: View {
    @ObservedObject var controller: GroceryListController

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    overallCard

                    VStack(alignment: .leading, spacing: 12) {
                        Text("By category")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColors.textMuted)
                            .padding(.horizontal, 4)

                        ForEach(controller.totalsByCategory(), id: \.category) { entry in
                            categoryRow(category: entry.category, total: entry.total)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var overallCard: some View {
        VStack(spacing: 14) {
            Text("₱\(controller.totalAll, specifier: "%.0f")")
                .font(.custom("Georgia", size: 32).weight(.semibold))
                .foregroundColor(AppColors.textPrimary)
            Text("Estimated total for this trip")
                .font(.system(size: 12))
                .foregroundColor(AppColors.textMuted)

            ProgressView(value: controller.progress)
                .progressViewStyle(.linear)
                .tint(AppColors.primaryAccent)
                .background(AppColors.chipBackground)
                .clipShape(Capsule())
                .padding(.top, 4)

            HStack {
                statBlock(title: "Spent", value: controller.totalBought, color: AppColors.primaryAccent)
                Spacer()
                statBlock(title: "Remaining", value: controller.totalRemaining, color: AppColors.secondaryAccent)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20).fill(AppColors.cardBackground))
        .shadow(color: AppColors.textPrimary.opacity(0.07), radius: 12, x: 0, y: 2)
    }

    private func statBlock(title: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(AppColors.textMuted)
            Text("₱\(value, specifier: "%.0f")")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
        }
    }

    private func categoryRow(category: GroceryCategory, total: Double) -> some View {
        let fraction = controller.totalAll > 0 ? total / controller.totalAll : 0
        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(AppColors.categoryColors[category] ?? AppColors.textMuted)
                        .frame(width: 8, height: 8)
                    Text(category.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                }
                Spacer()
                Text("₱\(total, specifier: "%.0f")")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AppColors.chipBackground)
                    Capsule()
                        .fill(AppColors.categoryColors[category] ?? AppColors.primaryAccent)
                        .frame(width: geo.size.width * fraction)
                }
            }
            .frame(height: 6)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.cardBackground))
    }
}
