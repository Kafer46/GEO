import SwiftUI
import MapKit

struct PlaceMapView: View {
    let place: Place

    @State private var position: MapCameraPosition

    init(place: Place) {
        self.place = place
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: place.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        ))
    }

    var body: some View {
        Map(position: $position) {
            Annotation(place.name, coordinate: place.coordinate) {
                VStack(spacing: 2) {
                    Text(place.name)
                        .font(.caption.bold())
                        .padding(6)
                        .background(.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundStyle(.red)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Image(systemName: place.icon.symbol)
                    .foregroundStyle(place.icon.color)
                VStack(alignment: .leading) {
                    Text(place.name).font(.headline)
                    Text(place.coordinateText).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .padding()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AllPlacesMapView: View {
    let places: [Place]

    var body: some View {
        Map(initialPosition: .automatic) {
            ForEach(places) { place in
                Marker(place.name, systemImage: place.icon.symbol, coordinate: place.coordinate)
                    .tint(place.icon.color)
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .navigationTitle("All Places")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlaceMapView(place: Place.samples[0])
    }
}
