import Foundation

enum GroceryCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case produce = "Produce"
    case dairy = "Dairy"
    case pantry = "Pantry"
    case meat = "Meat"
    case other = "Other"

    var id: String { rawValue }
}

struct GroceryItem: Identifiable, Codable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var quantity: Int
    var price: Double
    var category: GroceryCategory
    var bought: Bool

    var lineTotal: Double {
        price * Double(quantity)
    }
}

extension GroceryItem {
    static let sampleData: [GroceryItem] = [
        GroceryItem(name: "Sourdough bread", quantity: 1, price: 120, category: .pantry, bought: false),
        GroceryItem(name: "Heirloom tomatoes", quantity: 4, price: 80, category: .produce, bought: false),
        GroceryItem(name: "Whole milk", quantity: 1, price: 95, category: .dairy, bought: false),
        GroceryItem(name: "Baby spinach", quantity: 1, price: 65, category: .produce, bought: true),
        GroceryItem(name: "Free-range eggs", quantity: 12, price: 180, category: .dairy, bought: false),
        GroceryItem(name: "Olive oil", quantity: 1, price: 220, category: .pantry, bought: false),
        GroceryItem(name: "Chicken thighs", quantity: 4, price: 310, category: .meat, bought: false),
        GroceryItem(name: "Greek yogurt", quantity: 2, price: 140, category: .dairy, bought: true)
    ]
}
