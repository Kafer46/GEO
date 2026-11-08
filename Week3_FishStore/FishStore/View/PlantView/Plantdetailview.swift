import SwiftUI

/// Màn hình chi tiết: ảnh lớn của cây và phần mô tả.
struct PlantDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                productImage
                    .frame(height: 260)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 10) {
                    Text(product.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.04, green: 0.20, blue: 0.50))

                    HStack {
                        Text(priceText(product.price))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)

                        Spacer()

                        Text(product.stock > 0 ? "Còn \(product.stock) cây" : "Hết hàng")
                            .font(.subheadline)
                            .foregroundColor(product.stock > 0 ? .secondary : .orange)
                    }

                    Divider()

                    Text("Mô tả")
                        .font(.headline)

                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
            }
            .padding()
        }
        .background(
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
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Dùng ảnh trong Assets nếu có, chưa có thì hiện ảnh thay thế.
    @ViewBuilder
    private var productImage: some View {
        if UIImage(named: product.imageName) != nil {
            Image(product.imageName)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color.green.opacity(0.30), Color.green.opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
        }
    }

    /// 50000 -> "50.000đ"
    private func priceText(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        let text = formatter.string(from: NSNumber(value: price)) ?? "\(Int(price))"
        return text + "đ"
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(
            product: Product(
                name: "Cây Java Fern",
                categoryId: UUID(),
                price: 50000,
                imageName: "plant_javafern",
                description: "Dễ trồng, không cần nền, buộc vào đá hoặc lũa.",
                stock: 40
            )
        )
    }
}
