import SwiftUI

struct ContentView: View {
    @State private var inputN = ""
    @State private var squareResult = "-"
    @State private var cubeResult = "-"
    @State private var factorialResult = "-"
    @State private var primeResult = "-"
    @State private var singleError: String?

    @State private var inputA = ""
    @State private var inputB = ""
    @State private var gcdResult = "-"
    @State private var lcmResult = "-"
    @State private var pairError: String?

    @State private var showHelp = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    singleNumberCard
                    twoNumbersCard
                    bottomButtons
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showHelp) {
                HelpView()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Image(systemName: "sun.max.fill")
                .font(.system(size: 36))
                .foregroundStyle(.orange)
            Text("Number Tools")
                .font(.largeTitle.bold())
            Text("Small numbers, big possibilities!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var singleNumberCard: some View {
        CardView(title: "Single Number (n)") {
            TextField("Enter a number", text: $inputN)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)

            HStack(spacing: 8) {
                ToolButton(title: "n²", subtitle: "Square", color: .blue) { runSingle(.square) }
                ToolButton(title: "n³", subtitle: "Cube", color: .purple) { runSingle(.cube) }
                ToolButton(title: "n!", subtitle: "Factorial", color: .pink) { runSingle(.factorial) }
                ToolButton(title: "Prime?", subtitle: "Check", color: .green) { runSingle(.prime) }
            }

            if let singleError {
                ErrorText(message: singleError)
            }

            Text("Results for n = \(inputN.isEmpty ? "?" : inputN)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ResultCell(title: "n²", value: squareResult, color: .blue)
                ResultCell(title: "n³", value: cubeResult, color: .purple)
                ResultCell(title: "n!", value: factorialResult, color: .pink)
                ResultCell(title: "Prime?", value: primeResult, color: .green)
            }
        }
    }

    private var twoNumbersCard: some View {
        CardView(title: "Two Numbers (a, b)") {
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Enter a:").font(.caption)
                    TextField("a", text: $inputA)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numbersAndPunctuation)
                }
                VStack(alignment: .leading) {
                    Text("Enter b:").font(.caption)
                    TextField("b", text: $inputB)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numbersAndPunctuation)
                }
            }

            HStack(spacing: 8) {
                Button { runGCD() } label: {
                    Text("UCLN (GCD)").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button { runLCM() } label: {
                    Text("BCNN (LCM)").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }

            if let pairError {
                ErrorText(message: pairError)
            }

            Text("Results for a = \(inputA.isEmpty ? "?" : inputA), b = \(inputB.isEmpty ? "?" : inputB)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ResultCell(title: "UCLN (GCD)", value: gcdResult, color: .green)
                ResultCell(title: "BCNN (LCM)", value: lcmResult, color: .orange)
            }
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: 12) {
            Button(role: .destructive) { clearAll() } label: {
                Label("Clear All", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button { showHelp = true } label: {
                Label("Help", systemImage: "questionmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private enum SingleOperation {
        case square, cube, factorial, prime
    }

    private func readNumber(_ text: String) -> Int? {
        Int(text.trimmingCharacters(in: .whitespaces))
    }

    private func runSingle(_ operation: SingleOperation) {
        guard let n = readNumber(inputN) else {
            singleError = "Please enter a valid whole number (e.g. 5, -3)."
            return
        }
        singleError = nil

        switch operation {
        case .square:
            squareResult = NumberMath.square(n).map(String.init) ?? "Too large"
        case .cube:
            cubeResult = NumberMath.cube(n).map(String.init) ?? "Too large"
        case .factorial:
            if n < 0 {
                factorialResult = "-"
                singleError = "Factorial is not defined for negative numbers (n < 0)."
            } else {
                factorialResult = NumberMath.factorial(n).map(String.init) ?? "Too large"
            }
        case .prime:
            primeResult = NumberMath.isPrime(n) ? "Yes" : "No"
        }
    }

    private func readPair() -> (Int, Int)? {
        guard let a = readNumber(inputA), let b = readNumber(inputB) else {
            pairError = "Please enter two valid whole numbers."
            return nil
        }
        pairError = nil
        return (a, b)
    }

    private func runGCD() {
        guard let pair = readPair() else { return }
        let (a, b) = pair
        if a == 0 && b == 0 {
            gcdResult = "-"
            pairError = "UCLN(0, 0) is not defined."
            return
        }
        gcdResult = "\(NumberMath.gcd(a, b))"
    }

    private func runLCM() {
        guard let pair = readPair() else { return }
        let (a, b) = pair
        lcmResult = NumberMath.lcm(a, b).map(String.init) ?? "Too large"
    }

    private func clearAll() {
        inputN = ""
        inputA = ""
        inputB = ""
        squareResult = "-"
        cubeResult = "-"
        factorialResult = "-"
        primeResult = "-"
        gcdResult = "-"
        lcmResult = "-"
        singleError = nil
        pairError = nil
    }
}

struct CardView<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct ToolButton: View {
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption2)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.borderedProminent)
        .tint(color)
    }
}

struct ResultCell: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
    }
}

struct ErrorText: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(.footnote)
            .foregroundStyle(.red)
    }
}

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Single number (n)") {
                    Text("n² – square of n")
                    Text("n³ – cube of n")
                    Text("n! – factorial of n (n ≥ 0, up to 20)")
                    Text("Prime? – checks whether n is a prime number")
                }
                Section("Two numbers (a, b)") {
                    Text("UCLN (GCD) – greatest common divisor")
                    Text("BCNN (LCM) – least common multiple")
                }
                Section("Tips") {
                    Text("Only whole numbers are accepted.")
                    Text("Tap Clear All to reset every field and result.")
                }
            }
            .navigationTitle("Help")
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    ContentView()
}
