import SwiftUI

struct ContentView: View {
    let greeting = "Hello, Swift! 👋"
    let name = "Vo Tuan Kiet"
    let studentID = "SESEIU22029"
    let message = "My iOS journey starts today! 🚀"

    var body: some View {
        VStack(spacing: 16) {
            Text(greeting)
                .font(.largeTitle)
                .bold()

            Text("My name is \(name)")
                .font(.title2)

            Text("Student ID: \(studentID)")
                .font(.title3)

            Text(message)
                .font(.title3)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
