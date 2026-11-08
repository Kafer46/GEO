import SwiftUI

struct OrderListView: View {
    @Environment(OrderStore.self) private var store

    @State private var statusFilter: OrderStatus?
    @State private var sortByDistance = false
    @State private var showAddOrder = false

    private var displayedOrders: [Order] {
        var result = store.orders
        if let statusFilter {
            result = result.filter { $0.status == statusFilter }
        }
        if sortByDistance {
            result.sort { $0.displayDistanceKm < $1.displayDistanceKm }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("Trạng thái", selection: $statusFilter) {
                    Text("Tất cả").tag(OrderStatus?.none)
                    ForEach(OrderStatus.allCases) { status in
                        Text(status.rawValue).tag(OrderStatus?.some(status))
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Toggle(isOn: $sortByDistance) {
                    Label("Sắp xếp theo khoảng cách gần nhất", systemImage: "arrow.up.arrow.down")
                        .font(.subheadline)
                }
                .padding(.horizontal)

                if displayedOrders.isEmpty {
                    ContentUnavailableView("Không có đơn hàng", systemImage: "shippingbox")
                } else {
                    List {
                        ForEach(displayedOrders) { order in
                            NavigationLink {
                                OrderDetailView(order: order)
                            } label: {
                                OrderRow(order: order)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    store.deleteOrder(order)
                                } label: {
                                    Label("Xoá", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                Button {
                    showAddOrder = true
                } label: {
                    Label("Thêm đơn hàng", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)

                Text("Tổng số đơn hàng: \(store.orders.count)")
                    .foregroundStyle(.blue)
            }
            .padding(.vertical)
            .navigationTitle("Đơn Hàng Cần Giao")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        OrdersMapView()
                    } label: {
                        Image(systemName: "map")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Khôi phục dữ liệu mẫu", systemImage: "arrow.counterclockwise") {
                            store.resetToSampleData()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showAddOrder) {
                AddOrderView()
            }
            .task {
                await store.loadRoutes()
            }
        }
    }
}

struct OrderRow: View {
    let order: Order

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(order.restaurant.type.emoji)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(order.restaurant.name)
                        .font(.headline)
                    Spacer()
                    Text(order.distanceText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Text(order.restaurant.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Giao cho: \(order.customerName)")
                            .font(.subheadline)
                        Text(order.deliveryAddress)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    StatusTag(status: order.status)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusTag: View {
    let status: OrderStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color, in: Capsule())
    }
}

#Preview {
    OrderListView()
        .environment(OrderStore())
}
