import SwiftUI

struct AddOrderView: View {
    @Environment(OrderStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var selectedRestaurantId: UUID?
    @State private var addNewRestaurant = false
    @State private var restaurantName = ""
    @State private var restaurantAddress = ""
    @State private var restaurantLatitude = ""
    @State private var restaurantLongitude = ""
    @State private var restaurantType: RestaurantType = .other

    @State private var customerName = ""
    @State private var deliveryAddress = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Quán") {
                    Toggle("Thêm quán mới", isOn: $addNewRestaurant)
                    if addNewRestaurant {
                        TextField("Tên quán", text: $restaurantName)
                        TextField("Địa chỉ quán", text: $restaurantAddress)
                        TextField("Vĩ độ (latitude)", text: $restaurantLatitude)
                            .keyboardType(.numbersAndPunctuation)
                        TextField("Kinh độ (longitude)", text: $restaurantLongitude)
                            .keyboardType(.numbersAndPunctuation)
                        Picker("Loại quán", selection: $restaurantType) {
                            ForEach(RestaurantType.allCases) { type in
                                Text("\(type.emoji) \(type.rawValue)").tag(type)
                            }
                        }
                    } else {
                        Picker("Chọn quán", selection: $selectedRestaurantId) {
                            Text("Chưa chọn").tag(UUID?.none)
                            ForEach(store.restaurants) { restaurant in
                                Text("\(restaurant.type.emoji) \(restaurant.name)").tag(UUID?.some(restaurant.id))
                            }
                        }
                    }
                }

                Section("Khách hàng") {
                    TextField("Tên khách hàng", text: $customerName)
                    TextField("Địa chỉ giao", text: $deliveryAddress)
                    TextField("Vĩ độ (latitude)", text: $latitude)
                        .keyboardType(.numbersAndPunctuation)
                    TextField("Kinh độ (longitude)", text: $longitude)
                        .keyboardType(.numbersAndPunctuation)
                }

                if let errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Thêm đơn hàng")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Huỷ") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lưu") { save() }
                }
            }
            .onAppear {
                if selectedRestaurantId == nil {
                    selectedRestaurantId = store.restaurants.first?.id
                }
            }
        }
    }

    private func parseCoordinate(_ latText: String, _ lonText: String) -> (Double, Double)? {
        guard let lat = Double(latText.replacingOccurrences(of: ",", with: ".")), (-90...90).contains(lat),
              let lon = Double(lonText.replacingOccurrences(of: ",", with: ".")), (-180...180).contains(lon) else {
            return nil
        }
        return (lat, lon)
    }

    private func save() {
        let restaurant: Restaurant
        if addNewRestaurant {
            let name = restaurantName.trimmingCharacters(in: .whitespaces)
            guard !name.isEmpty else {
                errorMessage = "Vui lòng nhập tên quán."
                return
            }
            guard let coordinate = parseCoordinate(restaurantLatitude, restaurantLongitude) else {
                errorMessage = "Toạ độ quán không hợp lệ."
                return
            }
            restaurant = Restaurant(name: name, address: restaurantAddress, latitude: coordinate.0,
                                    longitude: coordinate.1, type: restaurantType)
        } else {
            guard let found = store.restaurants.first(where: { $0.id == selectedRestaurantId }) else {
                errorMessage = "Vui lòng chọn quán."
                return
            }
            restaurant = found
        }

        let customer = customerName.trimmingCharacters(in: .whitespaces)
        let address = deliveryAddress.trimmingCharacters(in: .whitespaces)
        guard !customer.isEmpty, !address.isEmpty else {
            errorMessage = "Vui lòng nhập tên khách hàng và địa chỉ giao."
            return
        }
        guard let coordinate = parseCoordinate(latitude, longitude) else {
            errorMessage = "Toạ độ địa chỉ giao không hợp lệ."
            return
        }

        if addNewRestaurant {
            store.addRestaurant(restaurant)
        }
        store.addOrder(Order(restaurant: restaurant, customerName: customer, address: address,
                             latitude: coordinate.0, longitude: coordinate.1))
        dismiss()
    }
}
