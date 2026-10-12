import Foundation

struct Product: Identifiable {
    let id = UUID()
    var name: String
    var categoryId: UUID
    var price: Double
    var imageName: String
    var description: String
    var stock: Int
}

struct ProductCategory: Identifiable {
    let id = UUID()
    var name: String
    var iconName: String
}
