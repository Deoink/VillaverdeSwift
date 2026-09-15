import SwiftUI
import Combine

/// Screen 3 of 4 — pushed from Home (add) or ItemDetailView (edit).
struct AddEditItemView: View {
    /// Pass an existing item to edit, or nil to add a new one.
    let editingItem: GroceryItem?
    @ObservedObject var controller: GroceryListController
    @Binding var path: NavigationPath

    @State private var name: String
    @State private var quantity: Int
    @State private var priceText: String
    @State private var category: GroceryCategory
    @State private var bought: Bool

    init(editingItem: GroceryItem?, controller: GroceryListController, path: Binding<NavigationPath>) {
        self.editingItem = editingItem
        self.controller = controller
        self._path = path
        _name = State(initialValue: editingItem?.name ?? "")
        _quantity = State(initialValue: editingItem?.quantity ?? 1)
        _priceText = State(initialValue: editingItem.flatMap { $0.price > 0 ? String(format: "%.0f", $0.price) : "" } ?? "")
        _category = State(initialValue: editingItem?.category ?? .produce)
        _bought = State(initialValue: editingItem?.bought ?? false)
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
        VStack(spacing: 0) {
            // Name field
            fieldLabel("Item name")
            TextField("e.g. Cherry tomatoes", text: $name)
                .textFieldStyle(SoftFieldStyle())
                .padding(.bottom, 16)

            // Qty + Price row
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    fieldLabel("Qty")
                    HStack {
                        stepperButton("minus") { quantity = max(1, quantity - 1) }
                        Spacer()
                        Text("\(quantity)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                        stepperButton("plus") { quantity += 1 }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.background))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.fieldBorder, lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 6) {
                    fieldLabel("Price (₱)")
                    TextField("0", text: $priceText)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(SoftFieldStyle())
                }
            }
            .padding(.bottom, 16)

            // Category chips
            fieldLabel("Category")
            FlowChips(category: $category)
                .padding(.bottom, 16)

            // Bought toggle
            HStack {
                fieldLabel("Mark as bought")
                Spacer()
                Toggle("", isOn: $bought)
                    .labelsHidden()
                    .tint(AppColors.primaryAccent)
            }
            .padding(.bottom, 24)

            // Save button
            Button(action: save) {
                Text(editingItem == nil ? "Add to list" : "Save changes")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(canSave ? AppColors.primaryAccent : AppColors.boughtMuted))
            }
            .disabled(!canSave)
            .padding(.bottom, 10)

            Button("Cancel") { path.removeLast() }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColors.textPrimary.opacity(0.55))
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 24)
        }
        .background(AppColors.background)
        .navigationTitle(editingItem == nil ? "Add Item" : "Edit Item")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(AppColors.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func stepperButton(_ systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .frame(width: 26, height: 26)
                .background(Circle().fill(AppColors.chipBackground))
        }
        .buttonStyle(.plain)
    }

    private func save() {
        let price = Double(priceText) ?? 0
        let item = GroceryItem(
            id: editingItem?.id ?? UUID().uuidString,
            name: name,
            quantity: quantity,
            price: price,
            category: category,
            bought: bought
        )
        if editingItem != nil {
            controller.updateItem(item)
        } else {
            controller.addItem(item)
        }
        // Pop back: from Home (add) this removes 1 level; from ItemDetailView
        // (edit) this also removes just this screen, landing back on the detail view.
        path.removeLast()
    }
}

/// Text field styled to match the cozy/warm theme.
private struct SoftFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 14))
            .foregroundColor(AppColors.textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.background))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.fieldBorder, lineWidth: 1))
    }
}

/// Wrapping row of category selection chips.
private struct FlowChips: View {
    @Binding var category: GroceryCategory

    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(GroceryCategory.allCases) { cat in
                let isSelected = cat == category
                Button {
                    category = cat
                } label: {
                    Text(cat.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule().fill(isSelected ? AppColors.secondaryAccent : (AppColors.categoryBackgrounds[cat] ?? AppColors.chipBackground))
                        )
                        .foregroundColor(isSelected ? .white : (AppColors.categoryColors[cat] ?? AppColors.textMuted))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
