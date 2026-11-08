import SwiftUI
import MapKit

struct OrderDetailView: View {
    let order: Order

    @Environment(OrderStore.self) private var store
    @State private var route: MKRoute?
    @State private var isLoadingRoute = true

    private var statusBinding: Binding<OrderStatus> {
        Binding(
            get: { order.status },
            set: { store.updateStatus(of: order, to: $0) }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Map(initialPosition: .automatic) {
                Annotation(order.restaurant.name, coordinate: order.restaurant.coordinate) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white, .red)
                }
                Annotation("Địa chỉ giao", coordinate: order.coordinate) {
                    Image(systemName: "house.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white, .blue)
                }
                if let route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .mapControls {
                MapCompass()
                MapScaleView()
            }

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                    VStack(alignment: .leading) {
                        Text("\(order.restaurant.type.emoji) \(order.restaurant.name)")
                            .font(.headline)
                        Text(order.restaurant.address)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    Image(systemName: "house.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    VStack(alignment: .leading) {
                        Text("Giao cho: \(order.customerName)")
                            .font(.headline)
                        Text(order.deliveryAddress)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack(spacing: 12) {
                    Image(systemName: "car.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                    if isLoadingRoute {
                        ProgressView()
                        Text("Đang tính đường đi...")
                    } else if let km = order.routeDistanceKm, let minutes = order.routeMinutes {
                        Text("Khoảng cách: \(km, specifier: "%.1f") km (≈ \(Int(minutes.rounded())) phút)")
                    } else {
                        Text("Khoảng cách (đường thẳng): \(order.straightDistanceKm, specifier: "%.1f") km")
                    }
                }
                .font(.subheadline)

                Picker("Trạng thái", selection: statusBinding) {
                    ForEach(OrderStatus.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle("Chi tiết đơn hàng")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let result = await MapService.getRoute(from: order.restaurant.coordinate, to: order.coordinate) {
                route = result.route
                order.routeDistanceKm = result.distanceKm
                order.routeMinutes = result.minutes
            }
            isLoadingRoute = false
        }
    }
}
