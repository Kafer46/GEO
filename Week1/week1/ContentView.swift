import SwiftUI

struct ContentView: View {
    @State private var inputN = ""
    @State private var result = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Number Calculator")
                .font(.largeTitle)
                .bold()

            HStack {
                Text("Enter n:")
                Spacer()
            }

            TextField("Enter a number", text: $inputN)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)

            calculatorButton(title: "Calculate n²", color: .blue) { n in
                let (value, overflow) = n.multipliedReportingOverflow(by: n)
                return overflow ? nil : value
            }

            calculatorButton(title: "Calculate n³", color: .purple) { n in
                let (square, overflow1) = n.multipliedReportingOverflow(by: n)
                let (cube, overflow2) = square.multipliedReportingOverflow(by: n)
                return overflow1 || overflow2 ? nil : cube
            }

            calculatorButton(title: "Double n", color: .green) { n in
                let (value, overflow) = n.multipliedReportingOverflow(by: 2)
                return overflow ? nil : value
            }

            Text("Result: \(result)")
                .font(.title3)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }

    private func calculatorButton(title: String, color: Color, operation: @escaping (Int) -> Int?) -> some View {
        Button {
            guard let n = Int(inputN.trimmingCharacters(in: .whitespaces)) else {
                result = "Please enter a valid number."
                return
            }
            if let value = operation(n) {
                result = "\(value)"
            } else {
                result = "Number is too large."
            }
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
    }
}

#Preview {
    ContentView()
}
