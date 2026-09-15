import Foundation
import SwiftUI
import Combine
/// MVC "Controller" layer. Owns the grocery data and every CRUD operation
/// plus derived values (totals, filtering, grouping). Views read from and
/// call into this controller — they hold no data logic themselves.
@MainActor
final class GroceryListController: ObservableObject {
    @Published var items: [GroceryItem] = GroceryItem.sampleData
    @Published var activeFilter: GroceryCategory? = nil // nil = "All"

    // MARK: - Create / Update / Delete (CRUD)

    func addItem(_ item: GroceryItem) {
        items.append(item)
    }

    func updateItem(_ item: GroceryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }

    func deleteItem(_ item: GroceryItem) {
        items.removeAll { $0.id == item.id }
    }

    func toggleBought(_ item: GroceryItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].bought.toggle()
    }

    // MARK: - Read / derived data

    var filteredItems: [GroceryItem] {
        guard let filter = activeFilter else { return items }
        return items.filter { $0.category == filter }
    }

    var activeItems: [GroceryItem] {
        filteredItems.filter { !$0.bought }
    }

    var boughtItems: [GroceryItem] {
        filteredItems.filter { $0.bought }
    }

    func groupedActiveItems() -> [(category: GroceryCategory, items: [GroceryItem])] {
        GroceryCategory.allCases.compactMap { category in
            let matches = activeItems.filter { $0.category == category }
            return matches.isEmpty ? nil : (category, matches)
        }
    }

    var totalAll: Double {
        items.reduce(0) { $0 + $1.lineTotal }
    }

    var totalBought: Double {
        items.filter { $0.bought }.reduce(0) { $0 + $1.lineTotal }
    }

    var totalRemaining: Double {
        totalAll - totalBought
    }

    var progress: Double {
        totalAll > 0 ? totalBought / totalAll : 0
    }

    /// Spend per category, for the Summary screen.
    func totalsByCategory() -> [(category: GroceryCategory, total: Double)] {
        GroceryCategory.allCases.compactMap { category in
            let total = items.filter { $0.category == category }.reduce(0) { $0 + $1.lineTotal }
            return total > 0 ? (category, total) : nil
        }
    }
}
