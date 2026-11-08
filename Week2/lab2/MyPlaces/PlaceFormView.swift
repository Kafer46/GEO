import SwiftUI

struct PlaceFormView: View {
    let title: String
    let onSave: (String, Double, Double) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var latitude: String
    @State private var longitude: String
    @State private var errorMessage: String?

    init(title: String, place: Place? = nil, onSave: @escaping (String, Double, Double) -> Void) {
        self.title = title
        self.onSave = onSave
        _name = State(initialValue: place?.name ?? "")
        _latitude = State(initialValue: place.map { String($0.latitude) } ?? "")
        _longitude = State(initialValue: place.map { String($0.longitude) } ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Place Information") {
                    TextField("Name", text: $name)
                    TextField("Latitude (-90 → 90)", text: $latitude)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("Longitude (-180 → 180)", text: $longitude)
                        .keyboardType(.numbersAndPunctuation)
                }

                if let errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a place name."
            return
        }
        guard let lat = Double(latitude.replacingOccurrences(of: ",", with: ".")), (-90...90).contains(lat) else {
            errorMessage = "Latitude must be a number between -90 and 90."
            return
        }
        guard let lon = Double(longitude.replacingOccurrences(of: ",", with: ".")), (-180...180).contains(lon) else {
            errorMessage = "Longitude must be a number between -180 and 180."
            return
        }
        onSave(trimmedName, lat, lon)
        dismiss()
    }
}

#Preview {
    PlaceFormView(title: "Add Place") { _, _, _ in }
}
