import SwiftUI

/// Screen 1 of 4 — the main list screen ("My Basket").
struct ContentView: View {
    @StateObject private var controller = GroceryListController()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                AppColors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    estimatedTotalCard
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    filterChips
                        .padding(.top, 14)

                    if controller.activeItems.isEmpty && controller.boughtItems.isEmpty {
                        ScrollView { emptyState }
                    } else {
                        listContent
                    }
                }

                fab
            }
            .navigationTitle("My Basket")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(Route.summary)
                    } label: {
                        Image(systemName: "chart.pie")
                            .foregroundColor(AppColors.primaryAccent)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .itemDetail(let item):
                    ItemDetailView(item: item, controller: controller, path: $path)
                case .addEditItem(let item):
                    AddEditItemView(editingItem: item, controller: controller, path: $path)
                case .summary:
                    SummaryView(controller: controller)
                }
            }
        }
    }

    // MARK: - Estimated total card

    private var estimatedTotalCard: some View {
        VStack(spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "basket")
                        .foregroundColor(AppColors.primaryAccent)
                        .font(.system(size: 13))
                    Text("Estimated Total")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.textMuted)
                }
                Spacer()
                Text("₱\(controller.totalAll, specifier: "%.0f")")
                    .font(.custom("Georgia", size: 16).weight(.semibold))
                    .foregroundColor(AppColors.textPrimary)
            }

            ProgressView(value: controller.progress)
                .progressViewStyle(.linear)
                .tint(AppColors.primaryAccent)
                .background(AppColors.chipBackground)
                .clipShape(Capsule())

            HStack {
                Text("₱\(controller.totalBought, specifier: "%.0f") spent")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(AppColors.boughtMuted)
                Spacer()
                Text("₱\(controller.totalRemaining, specifier: "%.0f") remaining")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(AppColors.secondaryAccent)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20).fill(AppColors.cardBackground))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColors.chipBackground, lineWidth: 1))
        .shadow(color: AppColors.textPrimary.opacity(0.07), radius: 12, x: 0, y: 2)
    }

    // MARK: - Filter chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "All", isSelected: controller.activeFilter == nil) {
                    controller.activeFilter = nil
                }
                ForEach(GroceryCategory.allCases) { cat in
                    filterChip(title: cat.rawValue, isSelected: controller.activeFilter == cat) {
                        controller.activeFilter = cat
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(isSelected ? AppColors.secondaryAccent : AppColors.chipBackground))
                .foregroundColor(isSelected ? .white : Color(hex: "7A736C"))
        }
        .buttonStyle(.plain)
    }

    // MARK: - List content

    private var listContent: some View {
        List {
            ForEach(controller.groupedActiveItems(), id: \.category) { group in
                Section(header: sectionHeader(title: group.category.rawValue)) {
                    ForEach(group.items) { item in
                        row(for: item)
                    }
                }
            }
            if !controller.boughtItems.isEmpty {
                Section(header: sectionHeader(title: "In the basket ✓", muted: true)) {
                    ForEach(controller.boughtItems) { item in
                        row(for: item)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
    }

    private func row(for item: GroceryItem) -> some View {
        NavigationLink(value: Route.itemDetail(item)) {
            GroceryItemRow(item: item, onToggle: { controller.toggleBought(item) })
        }
        .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                controller.deleteItem(item)
            } label: {
                Label("Remove", systemImage: "trash")
            }
            .tint(AppColors.deleteAccent)
        }
    }

    private func sectionHeader(title: String, muted: Bool = false) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(Capsule().fill(muted ? Color(hex: "EEEBE6") : AppColors.chipBackground))
                .foregroundColor(muted ? AppColors.textMuted : AppColors.textPrimary)
            Rectangle()
                .fill(Color(hex: "E8E1D9"))
                .frame(height: 1)
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .textCase(nil)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 56))
                .foregroundColor(AppColors.primaryAccent.opacity(0.5))
            Text("Nothing here yet —\nadd your first item")
                .multilineTextAlignment(.center)
                .font(.custom("Georgia", size: 16).italic())
                .foregroundColor(AppColors.textMuted)
        }
        .padding(.top, 100)
    }

    // MARK: - FAB

    private var fab: some View {
        Button {
            path.append(Route.addEditItem(nil))
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Circle().fill(AppColors.primaryAccent))
                .shadow(color: AppColors.primaryAccent.opacity(0.38), radius: 14, x: 0, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 28)
    }
}

#Preview {
    ContentView()
}
