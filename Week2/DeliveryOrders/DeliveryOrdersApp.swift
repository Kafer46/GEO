import SwiftUI

@main
struct DeliveryOrdersApp: App {
    @State private var store = OrderStore()

    var body: some Scene {
        WindowGroup {
            OrderListView()
                .environment(store)
        }
    }
}
