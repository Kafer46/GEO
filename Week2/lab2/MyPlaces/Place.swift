import Foundation
import CoreLocation
import SwiftUI

@Observable
final class Place: Identifiable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var coordinateText: String {
        String(format: "%.4f, %.4f", latitude, longitude)
    }

    var icon: (symbol: String, color: Color) {
        let lowered = name.lowercased()
        if lowered.contains("hcmute") || lowered.contains("school") || lowered.contains("university") {
            return ("graduationcap.fill", .blue)
        }
        if lowered.contains("home") || lowered.contains("nhà") {
            return ("house.fill", .orange)
        }
        if lowered.contains("coffee") || lowered.contains("cafe") || lowered.contains("cà phê") {
            return ("cup.and.saucer.fill", .brown)
        }
        if lowered.contains("park") || lowered.contains("công viên") {
            return ("tree.fill", .green)
        }
        if lowered.contains("library") || lowered.contains("thư viện") {
            return ("books.vertical.fill", .purple)
        }
        return ("mappin.circle.fill", .red)
    }

    static var samples: [Place] {
        [
            Place(name: "HCMUTE", latitude: 10.8506, longitude: 106.7719),
            Place(name: "Home", latitude: 10.9500, longitude: 106.8200),
            Place(name: "Coffee Shop", latitude: 10.8752, longitude: 106.8012),
            Place(name: "Park", latitude: 10.8601, longitude: 106.7930)
        ]
    }
}
