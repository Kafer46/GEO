import Foundation
import MapKit

struct RouteResult {
    let distanceKm: Double
    let minutes: Double
    let route: MKRoute
}

enum MapService {
    static func getRoute(from source: CLLocationCoordinate2D,
                         to destination: CLLocationCoordinate2D) async -> RouteResult? {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        do {
            let response = try await MKDirections(request: request).calculate()
            guard let route = response.routes.first else { return nil }
            return RouteResult(distanceKm: route.distance / 1000,
                               minutes: route.expectedTravelTime / 60,
                               route: route)
        } catch {
            return nil
        }
    }
}
