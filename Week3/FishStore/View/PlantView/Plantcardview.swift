import SwiftUI

/// Thẻ hiển thị một sản phẩm cây thủy sinh trong lưới.
struct PlantCardView: View {
    let product: Product
    let isFavorite: Bool
    var onToggleFavorite: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            productImage
                .frame(height: 110)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(product.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.04, green: 0.20, blue: 0.50))
                .lineLimit(1)

            // Hàng dưới cùng: giá + tồn kho bên trái, tim bên phải
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(priceText(product.price))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)

                    Text(product.stock > 0 ? "Còn \(product.stock) cây" : "Hết hàng")
                        .font(.caption)
                        .foregroundColor(product.stock > 0 ? .secondary : .orange)
                }

                Spacer()

                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
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
                    .font(.system(size: 40))
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
    PlantCardView(
        product: Product(
            name: "Cây Java Fern",
            categoryId: UUID(),
            price: 50000,
            imageName: "plant_javafern",
            description: "Dễ trồng, không cần nền, buộc vào đá hoặc lũa.",
            stock: 40
        ),
        isFavorite: true
    )
    .frame(width: 180)
    .padding()
}
