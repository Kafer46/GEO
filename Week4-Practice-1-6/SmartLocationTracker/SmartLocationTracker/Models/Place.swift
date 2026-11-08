import Foundation
import CoreLocation

struct Place: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String?

    init(id: UUID = UUID(),
         name: String,
         latitude: Double,
         longitude: Double,
         address: String? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension Place {
    static let samples: [Place] = [
        Place(name: "HCMUTE", latitude: 10.8506, longitude: 106.7719,
              address: "Ho Chi Minh City University of Technology and Education"),
        Place(name: "Ben Thanh Market", latitude: 10.7725, longitude: 106.6980,
              address: "District 1, Ho Chi Minh City"),
        Place(name: "Suoi Tien Park", latitude: 10.8657, longitude: 106.8020,
              address: "Thu Duc City, Ho Chi Minh City"),
        Place(name: "Diamond Island", latitude: 10.7705, longitude: 106.7494,
              address: "Thu Duc City, Ho Chi Minh City")
    ]
}

func formatDistance(_ meters: Double) -> String {
    meters < 1000 ? String(format: "%.0f m", meters) : String(format: "%.2f km", meters / 1000)
}
