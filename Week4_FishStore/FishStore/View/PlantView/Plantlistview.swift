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
        plants = TextFileStore.loadProducts("plant.txt", category: plantCategory)
    }
}

#Preview {
    PlantListView()
}
