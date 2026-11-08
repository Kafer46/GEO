import SwiftUI

struct MapScreenView: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        NavigationStack {
            MapView(locationManager: locationManager)
                .navigationTitle("Map")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MapScreenView(locationManager: LocationManager())
}
