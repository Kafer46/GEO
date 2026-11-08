import SwiftUI
import CoreLocation

struct LocationInfoView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        let location = locationManager.currentLocation
        VStack(spacing: 10) {
            InfoRow(title: "Latitude",
                    value: location.map { String(format: "%.4f°", $0.coordinate.latitude) } ?? "-")
            InfoRow(title: "Longitude",
                    value: location.map { String(format: "%.4f°", $0.coordinate.longitude) } ?? "-")
            InfoRow(title: "Altitude",
                    value: location.map { String(format: "%.1f m", $0.altitude) } ?? "-")
            InfoRow(title: "Accuracy",
                    value: location.map { String(format: "± %.1f m", $0.horizontalAccuracy) } ?? "-")
            InfoRow(title: "Last update",
                    value: locationManager.lastUpdateTime?.formatted(date: .omitted, time: .standard) ?? "-")
            InfoRow(title: "Services enabled",
                    value: locationManager.servicesEnabled ? "Yes" : "No",
                    valueColor: locationManager.servicesEnabled ? .green : .red)
            InfoRow(title: "Permission",
                    value: locationManager.permissionText,
                    valueColor: locationManager.isAuthorized ? .green : .red)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    LocationInfoView(locationManager: LocationManager())
        .padding()
}
