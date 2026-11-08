import SwiftUI
import MapKit

struct OrdersMapView: View {
    @Environment(OrderStore.self) private var store

    var body: some View {
        Map(initialPosition: .automatic) {
            ForEach(store.restaurants) { restaurant in
                Annotation(restaurant.name, coordinate: restaurant.coordinate) {
                    Text(restaurant.type.emoji)
                        .font(.title2)
                        .padding(4)
                        .background(.white, in: Circle())
                        .shadow(radius: 2)
                }
            }
            ForEach(store.orders) { order in
                Marker(order.customerName, systemImage: "house.fill", coordinate: order.coordinate)
                    .tint(order.status.color)
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 16) {
                ForEach(OrderStatus.allCases) { status in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(status.color)
                            .frame(width: 10, height: 10)
                        Text(status.rawValue)
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(.thinMaterial, in: Capsule())
            .padding()
        }
        .navigationTitle("Bản đồ đơn hàng")
        .navigationBarTitleDisplayMode(.inline)
    }
}
