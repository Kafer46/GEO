import SwiftUI

@main
struct SchoolManagementApp: App {
    @State private var controller = SchoolController.withSampleData()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(controller)
        }
    }
}
