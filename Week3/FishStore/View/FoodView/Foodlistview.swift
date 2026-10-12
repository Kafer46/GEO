import SwiftUI

/// Màn hình danh mục "Thức ăn": 4 loại thức ăn cho cá, tìm kiếm, yêu thích.
struct FoodListView: View {
    @State private var foods: [Product] = []
    @State private var searchText = ""
    @State private var favoriteIds: Set<UUID> = []

    private let foodCategory = ProductCategory(name: "Thức ăn", iconName: "icon_food")

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var filteredFoods: [Product] {
        let keyword = searchText.trimmingCharacters(in: .whitespaces)
        if keyword.isEmpty { return foods }
        return foods.filter { $0.name.localizedCaseInsensitiveContains(keyword) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if filteredFoods.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                        Text("Không tìm thấy thức ăn phù hợp")
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredFoods) { food in
                            // Bấm vào thẻ để mở màn chi tiết
                            NavigationLink {
                                FoodDetailView(product: food)
                            } label: {
                                FoodCardView(
                                    product: food,
                                    isFavorite: favoriteIds.contains(food.id),
                                    onToggleFavorite: { toggleFavorite(food) }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
            }
            .background(
                // Nền xanh biển: nhạt ở trên, đậm dần xuống dưới
                LinearGradient(
                    colors: [
                        Color(red: 0.78, green: 0.93, blue: 0.98),
                        Color(red: 0.25, green: 0.62, blue: 0.85)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle(foodCategory.name)
            .searchable(text: $searchText, prompt: "Tìm thức ăn cho cá...")
            .onAppear {
                if foods.isEmpty { loadSampleData() }
            }
        }
    }

    private func toggleFavorite(_ food: Product) {
        if favoriteIds.contains(food.id) {
            favoriteIds.remove(food.id)
        } else {
            favoriteIds.insert(food.id)
        }
    }

    /// Dữ liệu mẫu: 4 loại thức ăn cho cá.
    private func loadSampleData() {
        let id = foodCategory.id
        foods = [
            Product(name: "Cám viên nổi", categoryId: id, price: 45000,
                    imageName: "food_pellet",
                    description: "Viên nhỏ nổi trên mặt nước, dùng hằng ngày cho cá ăn tầng mặt như cá vàng, cá bảy màu.",
                    stock: 50),
            Product(name: "Thức ăn dạng mảnh", categoryId: id, price: 60000,
                    imageName: "food_flake",
                    description: "Mảnh mỏng, mềm, dễ ăn, hợp với cá nhỏ như neon và cá bảy màu.",
                    stock: 30),
            Product(name: "Trùn chỉ sấy khô", categoryId: id, price: 35000,
                    imageName: "food_bloodworm",
                    description: "Giàu đạm, giúp cá lên màu và mau lớn. Nên cho ăn bổ sung 2 đến 3 lần mỗi tuần.",
                    stock: 20),
            Product(name: "Artemia sấy khô", categoryId: id, price: 80000,
                    imageName: "food_artemia",
                    description: "Giàu dinh dưỡng, hợp với cá con và cá betta.",
                    stock: 12)
        ]
    }
}

#Preview {
    FoodListView()
}
