import SwiftUI
import CoreLocation

struct SavedPlacesView: View {
    @ObservedObject var locationManager: LocationManager

    @State private var showAddAlert = false
    @State private var showNoLocationAlert = false
    @State private var newPlaceName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(locationManager.places) { place in
                    NavigationLink {
                        PlaceDetailView(place: place, locationManager: locationManager)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.red)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(place.name)
                                    .font(.headline)
                                Text(String(format: "%.4f, %.4f", place.latitude, place.longitude))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: locationManager.deletePlace)
            }
            .overlay {
                if locationManager.places.isEmpty {
                    ContentUnavailableView("No Saved Places",
                                           systemImage: "mappin.slash",
                                           description: Text("Tap + to save your current location."))
                }
            }
            .navigationTitle("Saved Places")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if locationManager.currentLocation == nil {
                            locationManager.requestCurrentLocation()
                            showNoLocationAlert = true
                        } else {
                            newPlaceName = ""
                            showAddAlert = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Save Current Location", isPresented: $showAddAlert) {
                TextField("Place name", text: $newPlaceName)
                Button("Save") {
                    _ = locationManager.addPlace(name: newPlaceName)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter a name for this place.")
            }
            .alert("Location not available yet", isPresented: $showNoLocationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Getting your location... please try again in a moment.")
            }
        }
    }
}

#Preview {
    SavedPlacesView(locationManager: LocationManager())
}
