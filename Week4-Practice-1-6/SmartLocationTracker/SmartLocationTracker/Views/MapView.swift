import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager: LocationManager

    @State private var selectedPlace: Place?
    @State private var cameraPosition: MapCameraPosition = .userLocation(
        fallback: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 10.8231, longitude: 106.6297),
                span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
            )
        )
    )

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedPlace) {
            UserAnnotation()

            ForEach(locationManager.places) { place in
                Marker(place.name, systemImage: "mappin", coordinate: place.coordinate)
                    .tint(.red)
                    .tag(place)
            }
        }
        .mapStyle(.standard)
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .overlay(alignment: .top) {
            if locationManager.currentLocation == nil {
                Text("Waiting for location...")
                    .font(.footnote)
                    .padding(8)
                    .background(.thinMaterial, in: Capsule())
                    .padding(.top, 8)
            }
        }
        .onAppear {
            if !locationManager.isTracking {
                locationManager.requestCurrentLocation()
            }
        }
        .onChange(of: selectedPlace) { _, newPlace in
            guard let place = newPlace else { return }
            withAnimation {
                cameraPosition = .region(
                    MKCoordinateRegion(center: place.coordinate,
                                       latitudinalMeters: 1000,
                                       longitudinalMeters: 1000)
                )
            }
        }
        .sheet(item: $selectedPlace) { place in
            PlaceSummaryView(place: place, locationManager: locationManager)
                .presentationDetents([.fraction(0.3), .medium])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
    }
}

struct PlaceSummaryView: View {
    let place: Place
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundStyle(.red)
                Text(place.name)
                    .font(.title2.bold())
            }
            if let address = place.address {
                Text(address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Label(String(format: "%.4f, %.4f", place.latitude, place.longitude),
                  systemImage: "location")
                .font(.subheadline)
            HStack {
                Text("Distance from you:")
                Text(locationManager.distance(to: place).map(formatDistance) ?? "--")
                    .font(.title3.bold())
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MapView(locationManager: LocationManager())
}
