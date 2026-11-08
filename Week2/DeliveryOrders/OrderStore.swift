import Foundation

@Observable
final class OrderStore {
    var restaurants: [Restaurant] = []
    var orders: [Order] = []

    private let storageKey = "deliveryOrders"

    init() {
        load()
    }

    func addOrder(_ order: Order) {
        orders.append(order)
        save()
    }

    func addRestaurant(_ restaurant: Restaurant) {
        restaurants.append(restaurant)
        save()
    }

    func updateStatus(of order: Order, to status: OrderStatus) {
        order.status = status
        save()
    }

    func deleteOrder(_ order: Order) {
        orders.removeAll { $0.id == order.id }
        save()
    }

    func loadRoutes() async {
        for order in orders where order.routeDistanceKm == nil {
            if let result = await MapService.getRoute(from: order.restaurant.coordinate, to: order.coordinate) {
                order.routeDistanceKm = result.distanceKm
                order.routeMinutes = result.minutes
            }
        }
    }

    func resetToSampleData() {
        let samples = Self.sampleData()
        restaurants = samples.restaurants
        orders = samples.orders
        save()
    }

    private func save() {
        let archive = OrderArchive(
            restaurants: restaurants.map {
                RestaurantRecord(id: $0.id, name: $0.name, address: $0.address,
                                 latitude: $0.latitude, longitude: $0.longitude, type: $0.type)
            },
            orders: orders.map {
                OrderRecord(id: $0.id, restaurantId: $0.restaurant.id, customerName: $0.customerName,
                            deliveryAddress: $0.deliveryAddress, latitude: $0.latitude,
                            longitude: $0.longitude, status: $0.status)
            }
        )
        if let data = try? JSONEncoder().encode(archive) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let archive = try? JSONDecoder().decode(OrderArchive.self, from: data) else {
            let samples = Self.sampleData()
            restaurants = samples.restaurants
            orders = samples.orders
            return
        }

        let loadedRestaurants = archive.restaurants.map {
            Restaurant(id: $0.id, name: $0.name, address: $0.address,
                       latitude: $0.latitude, longitude: $0.longitude, type: $0.type)
        }
        restaurants = loadedRestaurants
        orders = archive.orders.compactMap { record in
            guard let restaurant = loadedRestaurants.first(where: { $0.id == record.restaurantId }) else { return nil }
            return Order(id: record.id, restaurant: restaurant, customerName: record.customerName,
                         address: record.deliveryAddress, latitude: record.latitude,
                         longitude: record.longitude, status: record.status)
        }
    }

    private static func sampleData() -> (restaurants: [Restaurant], orders: [Order]) {
        let pho = Restaurant(name: "Phở 24", address: "10 Nguyễn Văn Linh, Q.7",
                             latitude: 10.7290, longitude: 106.7215, type: .pho)
        let highlands = Restaurant(name: "Highlands Coffee", address: "72 Lê Lợi, Q.1",
                                   latitude: 10.7737, longitude: 106.7010, type: .coffee)
        let lotteria = Restaurant(name: "Lotteria", address: "285 Cách Mạng Tháng 8, Q.10",
                                  latitude: 10.7808, longitude: 106.6809, type: .burger)
        let pizza = Restaurant(name: "Pizza Hut", address: "1 Võ Văn Ngân, TP. Thủ Đức",
                               latitude: 10.8497, longitude: 106.7600, type: .pizza)

        let orders = [
            Order(restaurant: pho, customerName: "Nguyễn Văn A", address: "123 Lê Văn Sỹ, Q.3",
                  latitude: 10.7868, longitude: 106.6788, status: .pending),
            Order(restaurant: highlands, customerName: "Trần Thị B", address: "456 Điện Biên Phủ, Q.10",
                  latitude: 10.7740, longitude: 106.6795, status: .delivering),
            Order(restaurant: lotteria, customerName: "Lê Minh C", address: "789 Âu Cơ, Q.11",
                  latitude: 10.7790, longitude: 106.6430, status: .pending),
            Order(restaurant: pizza, customerName: "Phạm Thị D", address: "12 Hoàng Diệu 2, TP. Thủ Đức",
                  latitude: 10.8600, longitude: 106.7660, status: .delivered)
        ]
        return ([pho, highlands, lotteria, pizza], orders)
    }
}
