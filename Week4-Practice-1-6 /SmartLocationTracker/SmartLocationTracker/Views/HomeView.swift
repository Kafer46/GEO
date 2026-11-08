import SwiftUI
import CoreLocation

struct HomeView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var accuracyMode = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.blue)

                    HStack {
                        Circle()
                            .fill(locationManager.isTracking ? Color.green : Color.gray)
                            .frame(width: 10, height: 10)
                        Text(locationManager.isTracking ? "Tracking Active" : "Not Tracking")
                            .font(.headline)
                    }

                    LocationInfoView(locationManager: locationManager)

                    if locationManager.authorizationStatus == .notDetermined {
                        Button {
                            locationManager.requestPermission()
                        } label: {
                            Label("Request Location Permission", systemImage: "lock.open")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    HStack(spacing: 12) {
                        StatCard(title: "Total Distance",
                                 value: formatDistance(locationManager.totalDistance),
                                 icon: "point.topleft.down.to.point.bottomright.curvepath.fill",
                                 color: .blue)
                        StatCard(title: "Last Movement",
                                 value: formatDistance(locationManager.lastDistance),
                                 icon: "figure.walk",
                                 color: .green)
                    }

                    if let error = locationManager.errorMessage {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        locationManager.requestCurrentLocation()
                    } label: {
                        if locationManager.isRequesting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Label("Get Current Location", systemImage: "location.fill")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(locationManager.isRequesting)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tracking accuracy")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Picker("Accuracy", selection: $accuracyMode) {
                            Text("Best").tag(0)
                            Text("10 m").tag(1)
                            Text("100 m").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    .onChange(of: accuracyMode) { _, newValue in
                        switch newValue {
                        case 1:
                            locationManager.updateTrackingSettings(accuracy: kCLLocationAccuracyNearestTenMeters, distance: 10)
                        case 2:
                            locationManager.updateTrackingSettings(accuracy: kCLLocationAccuracyHundredMeters, distance: 100)
                        default:
                            locationManager.updateTrackingSettings(accuracy: kCLLocationAccuracyBest, distance: 10)
                        }
                    }

                    if locationManager.isTracking {
                        Button {
                            locationManager.stopTracking()
                        } label: {
                            Label("Stop Tracking", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    } else {
                        Button {
                            locationManager.startTracking()
                        } label: {
                            Label("Start Tracking", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Button("Reset Distance") {
                        locationManager.resetDistance()
                    }
                    .font(.footnote)
                }
                .padding()
            }
            .navigationTitle("Smart Location Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                locationManager.refreshStatus()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.1)))
    }
}

#Preview {
    HomeView(locationManager: LocationManager())
}
