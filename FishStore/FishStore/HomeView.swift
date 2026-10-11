// VO TUAN KIET

import SwiftUI

//------------------------------------
// Màu chủ đạo dùng chung
//------------------------------------
extension Color {
    static let brand = Color(red: 0.04, green: 0.43, blue: 0.74)
}

//------------------------------------
// Màn hình chính + thanh tab dưới cùng
//------------------------------------

struct HomeView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        LocationBarView()
                        BannerView()
                        CategoryRowView()
                        ProductSectionView()
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("KAT")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.brand)
                            .fixedSize()
                    }
                    .sharedBackgroundVisibility(.hidden)

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {

                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
            .tabItem {
                Label("Trang chủ", systemImage: "house")
            }

            Text("Giỏ hàng")
                .tabItem {
                    Label("Giỏ hàng", systemImage: "cart")
                }

            Text("Yêu thích")
                .tabItem {
                    Label("Yêu thích", systemImage: "heart")
                }

            Text("Thông báo")
                .tabItem {
                    Label("Thông báo", systemImage: "bell")
                }

            Text("Tài khoản")
                .tabItem {
                    Label("Tài khoản", systemImage: "person")
                }
        }
        .tint(Color.brand)
    }
}

//------------------------------------
// Thanh địa chỉ giao hàng
//------------------------------------

struct LocationBarView: View {
    var body: some View {
        Button {

        } label: {
            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(Color.brand)

                Text("Giao đến:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Chọn địa chỉ giao hàng")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.brand.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

//------------------------------------
// Banner khuyến mãi
//------------------------------------

struct BannerView: View {
    let features = [
        ("Giao hàng\nnhanh", "shippingbox"),
        ("Đóng gói\nan toàn", "checkmark.shield"),
        ("Tư vấn\nmiễn phí", "bubble.left.and.bubble.right")
    ]

    var body: some View {
        ZStack(alignment: .trailing) {
            // Nền
            LinearGradient(
                colors: [Color.brand, Color.teal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Hình trang trí
            Image(systemName: "fish.fill")
                .font(.system(size: 110))
                .foregroundStyle(.white.opacity(0.18))
                .rotationEffect(.degrees(-12))
                .offset(x: 20, y: -10)

            // Nội dung
            VStack(alignment: .leading, spacing: 8) {
                Text("ƯU ĐÃI THÁNG NÀY")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white)
                    .foregroundStyle(Color.brand)
                    .clipShape(Capsule())

                Text("Cá khỏe – Bể đẹp")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Không gian thư giãn cho mọi nhà")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))

                HStack(spacing: 8) {
                    ForEach(features, id: \.0) { feature in
                        VStack(spacing: 4) {
                            Image(systemName: feature.1)
                                .font(.callout)
                            Text(feature.0)
                                .font(.system(size: 10))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(Color.brand)
                        .frame(width: 72, height: 56)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.top, 4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

//------------------------------------
// Danh mục sản phẩm
//------------------------------------

struct CategoryRowView: View {
    let categories = [
        ("Cá", "fish"),
        ("Cây thủy sinh", "leaf"),
        ("Thức ăn", "fork.knife"),
        ("Phụ kiện", "wrench.and.screwdriver")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Danh mục")

            HStack {
                ForEach(categories, id: \.0) { category in
                    Button {

                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: category.1)
                                .font(.title2)
                                .foregroundStyle(Color.brand)
                                .frame(width: 60, height: 60)
                                .background(Color.brand.opacity(0.1))
                                .clipShape(Circle())

                            Text(category.0)
                                .font(.caption)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

//------------------------------------
// Sản phẩm nổi bật
//------------------------------------

struct ProductSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Sản phẩm nổi bật", actionTitle: "Xem tất cả")

            ContentUnavailableView(
                "Chưa có sản phẩm",
                systemImage: "shippingbox",
                description: Text("Sản phẩm nổi bật sẽ hiển thị tại đây")
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
        }
    }
}

//------------------------------------
// Tiêu đề mỗi phần 
//------------------------------------

struct SectionHeaderView: View {
    let title: String
    var actionTitle: String? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)

            Spacer()

            if let actionTitle {
                Button {

                } label: {
                    HStack(spacing: 2) {
                        Text(actionTitle)
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
