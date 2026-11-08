import SwiftUI
import MapKit

struct PlaceDetailView: View {
    let place: Place
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.red)

                Text(place.name)
                    .font(.title.bold())

                if let address = place.address {
                    Text(address)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 10) {
                    InfoRow(title: "Latitude", value: String(format: "%.6f", place.latitude))
                    InfoRow(title: "Longitude", value: String(format: "%.6f", place.longitude))
                    InfoRow(title: "Distance from you",
                            value: locationManager.distance(to: place).map(formatDistance) ?? "--",
                            valueColor: .blue)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))

                Map(initialPosition: .region(
                    MKCoordinateRegion(center: place.coordinate,
                                       latitudinalMeters: 800,
                                       longitudinalMeters: 800))) {
                    Marker(place.name, coordinate: place.coordinate)
                        .tint(.red)
                    UserAnnotation()
                }
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Place Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !locationManager.isTracking {
                locationManager.requestCurrentLocation()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlaceDetailView(place: Place.samples[0], locationManager: LocationManager())
    }
}
