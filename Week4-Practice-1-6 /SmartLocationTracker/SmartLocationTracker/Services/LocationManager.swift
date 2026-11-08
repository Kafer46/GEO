import Foundation
import CoreLocation
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var servicesEnabled: Bool = false

    @Published var currentLocation: CLLocation?
    @Published var lastUpdateTime: Date?
    @Published var errorMessage: String?
    @Published var isRequesting: Bool = false

    @Published var isTracking: Bool = false
    @Published var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    @Published var distanceFilter: CLLocationDistance = 10
    @Published var totalDistance: CLLocationDistance = 0
    @Published var lastDistance: CLLocationDistance = 0

    @Published var places: [Place] = [] {
        didSet { savePlaces() }
    }

    private var lastTrackedLocation: CLLocation?
    private let minDistanceThreshold: CLLocationDistance = 5
    private var pendingAction: (() -> Void)?
    private let placesKey = "savedPlaces"

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = desiredAccuracy
        manager.distanceFilter = distanceFilter
        loadPlaces()
        refreshStatus()
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    var permissionText: String {
        switch authorizationStatus {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedWhenInUse: return "Authorized When In Use"
        case .authorizedAlways: return "Authorized Always"
        @unknown default: return "Unknown"
        }
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func refreshStatus() {
        authorizationStatus = manager.authorizationStatus
        DispatchQueue.global().async {
            let enabled = CLLocationManager.locationServicesEnabled()
            DispatchQueue.main.async {
                self.servicesEnabled = enabled
            }
        }
    }

    private func withPermission(_ action: @escaping () -> Void) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            action()
        case .notDetermined:
            pendingAction = action
            manager.requestWhenInUseAuthorization()
        default:
            errorMessage = "Location permission denied. Enable it in Settings."
        }
    }

    func requestCurrentLocation() {
        withPermission { [weak self] in
            guard let self else { return }
            self.errorMessage = nil
            self.isRequesting = true
            self.manager.requestLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.isRequesting = false
            }
        }
    }

    func startTracking() {
        withPermission { [weak self] in
            guard let self else { return }
            self.errorMessage = nil
            self.lastTrackedLocation = nil
            self.manager.startUpdatingLocation()
            self.isTracking = true
        }
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
        isTracking = false
    }

    func updateTrackingSettings(accuracy: CLLocationAccuracy, distance: CLLocationDistance) {
        desiredAccuracy = accuracy
        distanceFilter = distance
        manager.desiredAccuracy = accuracy
        manager.distanceFilter = distance
    }

    func resetDistance() {
        totalDistance = 0
        lastDistance = 0
        lastTrackedLocation = nil
    }

    private func isValidLocation(_ location: CLLocation) -> Bool {
        location.horizontalAccuracy >= 0 && location.horizontalAccuracy <= 100
    }

    @discardableResult
    func addPlace(name: String) -> Bool {
        guard let location = currentLocation else { return false }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        let place = Place(name: trimmed.isEmpty ? "My Place" : trimmed,
                          latitude: location.coordinate.latitude,
                          longitude: location.coordinate.longitude,
                          address: "Saved on " + Date().formatted(date: .abbreviated, time: .shortened))
        places.append(place)
        return true
    }

    func deletePlace(at offsets: IndexSet) {
        places.remove(atOffsets: offsets)
    }

    func distance(to place: Place) -> CLLocationDistance? {
        guard let currentLocation else { return nil }
        return currentLocation.distance(from: place.location)
    }

    private func savePlaces() {
        if let data = try? JSONEncoder().encode(places) {
            UserDefaults.standard.set(data, forKey: placesKey)
        }
    }

    private func loadPlaces() {
        if let data = UserDefaults.standard.data(forKey: placesKey),
           let saved = try? JSONDecoder().decode([Place].self, from: data) {
            places = saved
        } else {
            places = Place.samples
        }
    }

    private func errorMessage(from error: Error) -> String {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied: return "Location permission denied."
            case .locationUnknown: return "Location unknown. Please try again."
            case .network: return "Network error."
            default: break
            }
        }
        return "Failed to get location: \(error.localizedDescription)"
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if let action = self.pendingAction {
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self.pendingAction = nil
                    action()
                } else if status == .denied || status == .restricted {
                    self.pendingAction = nil
                    self.errorMessage = "Location permission denied. Enable it in Settings."
                }
            }
        }
        refreshStatus()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        DispatchQueue.main.async {
            self.currentLocation = location
            self.lastUpdateTime = Date()
            self.isRequesting = false

            guard self.isTracking, self.isValidLocation(location) else { return }
            if let previous = self.lastTrackedLocation {
                let distance = location.distance(from: previous)
                if distance >= self.minDistanceThreshold {
                    self.lastDistance = distance
                    self.totalDistance += distance
                    self.lastTrackedLocation = location
                }
            } else {
                self.lastTrackedLocation = location
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        let message = errorMessage(from: error)
        DispatchQueue.main.async {
            self.isRequesting = false
            if let clError = error as? CLError, clError.code == .locationUnknown, self.isTracking { return }
            self.errorMessage = message
            if let clError = error as? CLError, clError.code == .denied {
                self.stopTracking()
            }
        }
    }
}
