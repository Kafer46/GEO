import SwiftUI

struct ContentView: View {
    @State private var inputN = ""
    @State private var result = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Calculate n²")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text("Enter n")
                Spacer()
            }
            
            TextField("Enter a number", text: $inputN)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            
            Button(" Calculate n²  ") {
                if let n = Int(inputN) {
                    let square = n * n
                    result = "\(square)"
                } else {
                    result = "Please enter a valid number"
                }
            }
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(15)
            
            Text("Result: \(result)")
                .font(.largeTitle)
        }
    }
}

#Preview {
    ContentView()
}
