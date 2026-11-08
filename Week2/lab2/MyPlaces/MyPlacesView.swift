import SwiftUI

struct MyPlacesView: View {
    @State private var places: [Place] = Place.samples
    @State private var searchText = ""
    @State private var showAddPlace = false
    @State private var editingPlace: Place?

    private var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return places
        }
        return places.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.red)
                    Text("My Places")
                        .font(.largeTitle.bold())
                    Text("Save places you love!")
                        .foregroundStyle(.gray)
                }

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search place...", text: $searchText)
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                if filteredPlaces.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List {
                        ForEach(filteredPlaces) { place in
                            NavigationLink {
                                PlaceMapView(place: place)
                            } label: {
                                PlaceRow(place: place)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deletePlace(place)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    editingPlace = place
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                Button {
                    showAddPlace = true
                } label: {
                    Label("Add Place", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Text("Total places: \(places.count)")
                    .foregroundStyle(.gray)
            }
            .padding(.vertical)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AllPlacesMapView(places: places)
                    } label: {
                        Image(systemName: "map")
                    }
                }
            }
            .sheet(isPresented: $showAddPlace) {
                PlaceFormView(title: "Add Place") { name, latitude, longitude in
                    places.append(Place(name: name, latitude: latitude, longitude: longitude))
                }
            }
            .sheet(item: $editingPlace) { place in
                PlaceFormView(title: "Edit Place", place: place) { name, latitude, longitude in
                    place.name = name
                    place.latitude = latitude
                    place.longitude = longitude
                }
            }
        }
    }

    private func deletePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
    }
}

struct PlaceRow: View {
    let place: Place

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: place.icon.symbol)
                .font(.title2)
                .foregroundStyle(place.icon.color)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(place.name)
                    .font(.headline)
                Text(place.coordinateText)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MyPlacesView()
}
