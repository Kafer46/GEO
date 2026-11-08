
import SwiftUI

/// Thẻ hiển thị một loại thức ăn cho cá trong lưới.
struct FoodCardView: View {
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

                    Text(product.stock > 0 ? "Còn \(product.stock) hộp" : "Hết hàng")
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
                    colors: [Color.orange.opacity(0.30), Color.orange.opacity(0.60)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }

    /// 45000 -> "45.000đ"
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
    FoodCardView(
        product: Product(
            name: "Cám viên nổi",
            categoryId: UUID(),
            price: 45000,
            imageName: "food_pellet",
            description: "Viên nhỏ nổi trên mặt nước, dùng hằng ngày.",
            stock: 50
        ),
        isFavorite: true
    )
    .frame(width: 180)
    .padding()
}
