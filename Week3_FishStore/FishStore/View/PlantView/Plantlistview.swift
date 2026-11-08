import SwiftUI

/// Màn hình danh mục "Cây thủy sinh": lưới sản phẩm, tìm kiếm, yêu thích.
struct PlantListView: View {
    @State private var plants: [Product] = []
    @State private var searchText = ""
    @State private var favoriteIds: Set<UUID> = []

    private let plantCategory = ProductCategory(name: "Cây thủy sinh", iconName: "icon_plant")

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var filteredPlants: [Product] {
        let keyword = searchText.trimmingCharacters(in: .whitespaces)
        if keyword.isEmpty { return plants }
        return plants.filter { $0.name.localizedCaseInsensitiveContains(keyword) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if filteredPlants.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                        Text("Không tìm thấy cây phù hợp")
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredPlants) { plant in
                            // Bấm vào thẻ để mở màn chi tiết
                            NavigationLink {
                                PlantDetailView(product: plant)
                            } label: {
                                PlantCardView(
                                    product: plant,
                                    isFavorite: favoriteIds.contains(plant.id),
                                    onToggleFavorite: { toggleFavorite(plant) }
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
            .navigationTitle(plantCategory.name)
            .searchable(text: $searchText, prompt: "Tìm cây thủy sinh...")
            .onAppear {
                if plants.isEmpty { loadSampleData() }
            }
        }
    }

    private func toggleFavorite(_ plant: Product) {
        if favoriteIds.contains(plant.id) {
            favoriteIds.remove(plant.id)
        } else {
            favoriteIds.insert(plant.id)
        }
    }

    /// Dữ liệu mẫu cho danh mục cây thủy sinh.
    private func loadSampleData() {
        let id = plantCategory.id
        plants = [
            Product(name: "Cây Java Fern", categoryId: id, price: 50000,
                    imageName: "plant_javafern",
                    description: "Dễ trồng, không cần nền, buộc vào đá hoặc lũa.", stock: 40),
            Product(name: "Cây Ráy Anubias Nana", categoryId: id, price: 65000,
                    imageName: "plant_anubias",
                    description: "Lá dày, chịu được ánh sáng yếu, lớn chậm.", stock: 35),
            Product(name: "Rêu Java", categoryId: id, price: 30000,
                    imageName: "plant_moss",
                    description: "Phủ lũa và đá, là chỗ trú cho cá con và tép.", stock: 60),
            Product(name: "Cây Vảy Ốc Đỏ", categoryId: id, price: 25000,
                    imageName: "plant_rotala",
                    description: "Cây cắt cắm hậu cảnh, ngọn ngả đỏ khi đủ sáng.", stock: 80),
            Product(name: "Cỏ Ngưu Mao Chiên", categoryId: id, price: 40000,
                    imageName: "plant_hairgrass",
                    description: "Trải nền tiền cảnh, cần ánh sáng mạnh và CO2.", stock: 25),
            Product(name: "Cây Hẹ Nước", categoryId: id, price: 20000,
                    imageName: "plant_vallisneria",
                    description: "Lá dài như dải lụa, hợp trồng hậu cảnh bể cao.", stock: 50),
            Product(name: "Cây Lưỡi Mác", categoryId: id, price: 55000,
                    imageName: "plant_echinodorus",
                    description: "Lá to bản, làm điểm nhấn giữa bể, cần nền dinh dưỡng.", stock: 15),
            Product(name: "Cây Diệp Tài Hồng", categoryId: id, price: 35000,
                    imageName: "plant_ludwigia",
                    description: "Lá hồng đỏ nổi bật, cần ánh sáng tốt để lên màu.", stock: 0)
        ]
    }
}

#Preview {
    PlantListView()
}
