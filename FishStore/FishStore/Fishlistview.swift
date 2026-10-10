import SwiftUI

/// Màn hình danh mục "Cá cảnh": lưới sản phẩm, tìm kiếm, yêu thích.
struct FishListView: View {
    @State private var fishes: [Product] = []
    @State private var searchText = ""
    @State private var favoriteIds: Set<UUID> = []

    private let fishCategory = ProductCategory(name: "Cá cảnh nè!", iconName: "icon_fish")
    
    init() {
        let darkBlue = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: darkBlue]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: darkBlue]
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var filteredFishes: [Product] {
        let keyword = searchText.trimmingCharacters(in: .whitespaces)
        if keyword.isEmpty { return fishes }
        return fishes.filter { $0.name.localizedCaseInsensitiveContains(keyword) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if filteredFishes.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                        Text("Không tìm thấy cá phù hợp")
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredFishes) { fish in
                            // Bấm vào thẻ để mở màn chi tiết
                            NavigationLink {
                                FishDetailView(product: fish)
                            } label: {
                                FishCardView(
                                    product: fish,
                                    isFavorite: favoriteIds.contains(fish.id),
                                    onToggleFavorite: { toggleFavorite(fish) }
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
                Image("ocean_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            
            .navigationTitle(fishCategory.name)
            .searchable(text: $searchText, prompt: "Tìm cá cảnh...")
            .onAppear {
                if fishes.isEmpty { loadSampleData() }
            }
        }
    }

    private func toggleFavorite(_ fish: Product) {
        if favoriteIds.contains(fish.id) {
            favoriteIds.remove(fish.id)
        } else {
            favoriteIds.insert(fish.id)
        }
    }

    /// Dữ liệu mẫu cho danh mục cá cảnh.
    private func loadSampleData() {
        let id = fishCategory.id
        fishes = [
            Product(name: "Cá Neon Tetra", categoryId: id, price: 20000,
                    imageName: "fish_neon",
                    description: "Cá nhỏ, bơi theo đàn, hợp bể thủy sinh.", stock: 120),
            Product(name: "Cá Betta Halfmoon", categoryId: id, price: 85000,
                    imageName: "fish_betta",
                    description: "Đuôi xòe hình bán nguyệt, nên nuôi riêng.", stock: 25),
            Product(name: "Cá Bảy Màu", categoryId: id, price: 10000,
                    imageName: "fish_guppy",
                    description: "Dễ nuôi, sinh sản nhanh, nhiều màu sắc.", stock: 200),
            Product(name: "Cá Vàng Ranchu", categoryId: id, price: 150000,
                    imageName: "fish_ranchu",
                    description: "Thân tròn, không vây lưng, bơi chậm.", stock: 12),
            Product(name: "Cá Koi Mini", categoryId: id, price: 120000,
                    imageName: "fish_koi",
                    description: "Hợp hồ ngoài trời hoặc bể lớn.", stock: 18),
            Product(name: "Cá Dĩa", categoryId: id, price: 350000,
                    imageName: "fish_discus",
                    description: "Cần nước sạch và nhiệt độ ổn định.", stock: 6),
            Product(name: "Cá Ông Tiên", categoryId: id, price: 45000,
                    imageName: "fish_angel",
                    description: "Dáng cao, vây dài, hợp bể cao.", stock: 30),
            Product(name: "Cá Chuột Panda", categoryId: id, price: 35000,
                    imageName: "fish_cory",
                    description: "Sống tầng đáy, giúp dọn thức ăn thừa.", stock: 0)
        ]
    }
}

#Preview {
    FishListView()
}
