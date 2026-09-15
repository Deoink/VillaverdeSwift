import Foundation

/// Every pushable screen in the app. Used with NavigationStack's
/// path-based, type-safe navigation (.navigationDestination(for:)).
enum Route: Hashable {
    case itemDetail(GroceryItem)
    case addEditItem(GroceryItem?) // nil = adding a new item
    case summary
}
