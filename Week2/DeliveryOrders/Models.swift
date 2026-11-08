import Foundation
import CoreLocation
import SwiftUI

enum RestaurantType: String, CaseIterable, Codable, Identifiable {
    case pho = "Phở"
    case coffee = "Cà phê"
    case burger = "Burger"
    case pizza = "Pizza"
    case other = "Khác"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .pho: return "🍜"
        case .coffee: return "☕️"
        case .burger: return "🍔"
        case .pizza: return "🍕"
        case .other: return "🍽️"
        }
    }
}

enum OrderStatus: String, CaseIterable, Codable, Identifiable {
    case pending = "Chưa giao"
    case delivering = "Đang giao"
    case delivered = "Đã giao"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .pending: return .blue
        case .delivering: return .orange
        case .delivered: return .green
        }
    }
}

@Observable
final class Restaurant: Identifiable {
    let id: UUID
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var type: RestaurantType

    init(id: UUID = UUID(), name: String, address: String, latitude: Double, longitude: Double, type: RestaurantType) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

@Observable
final class Order: Identifiable {
    let id: UUID
    var restaurant: Restaurant
    var customerName: String
    var deliveryAddress: String
    var latitude: Double
    var longitude: Double
    var status: OrderStatus
    var routeDistanceKm: Double?
    var routeMinutes: Double?

    init(id: UUID = UUID(),
         restaurant: Restaurant,
         customerName: String,
         address: String,
         latitude: Double,
         longitude: Double,
         status: OrderStatus = .pending) {
        self.id = id
        self.restaurant = restaurant
        self.customerName = customerName
        self.deliveryAddress = address
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var straightDistanceKm: Double {
        let from = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let to = CLLocation(latitude: latitude, longitude: longitude)
        return from.distance(from: to) / 1000
    }

    var displayDistanceKm: Double {
        routeDistanceKm ?? straightDistanceKm
    }

    var distanceText: String {
        String(format: "%.1f km", displayDistanceKm)
    }
}

struct RestaurantRecord: Codable {
    let id: UUID
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let type: RestaurantType
}

struct OrderRecord: Codable {
    let id: UUID
    let restaurantId: UUID
    let customerName: String
    let deliveryAddress: String
    let latitude: Double
    let longitude: Double
    let status: OrderStatus
}

struct OrderArchive: Codable {
    let restaurants: [RestaurantRecord]
    let orders: [OrderRecord]
}
