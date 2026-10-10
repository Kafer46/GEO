import SwiftUI

/// Thẻ hiển thị một sản phẩm cá cảnh trong lưới.
struct FishCardView: View {
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

                    Text(product.stock > 0 ? "Còn \(product.stock) con" : "Hết hàng")
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
                    colors: [Color.cyan.opacity(0.35), Color.blue.opacity(0.45)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                Image(systemName: "fish.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }

    /// 20000 -> "20.000đ"
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
    FishCardView(
        product: Product(
            name: "Cá Neon Tetra",
            categoryId: UUID(),
            price: 20000,
            imageName: "fish_neon",
            description: "Cá nhỏ, bơi theo đàn.",
            stock: 120
        ),
        isFavorite: true
    )
    .frame(width: 180)
    .padding()
}
