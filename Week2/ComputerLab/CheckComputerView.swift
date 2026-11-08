import SwiftUI

struct CheckComputerView: View {
    let computers: [Computer]

    @State private var computerName = ""
    @State private var resultMessage: String?
    @State private var found = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            TextField("Enter computer name (e.g. PC03)", text: $computerName)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.characters)

            Button {
                check()
            } label: {
                Text("Check")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            if let resultMessage {
                Label(resultMessage, systemImage: found ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(found ? .green : .red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background((found ? Color.green : Color.red).opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Check Computer")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func check() {
        let name = computerName.trimmingCharacters(in: .whitespaces).uppercased()
        guard !name.isEmpty else {
            found = false
            resultMessage = "Please enter a computer name."
            return
        }
        if let index = computers.firstIndex(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
            let computer = computers[index]
            found = true
            resultMessage = "\(computer.name) is in the lab (\(computer.location), position \(index + 1))."
        } else {
            found = false
            resultMessage = "\(name) is not in the lab."
        }
    }
}

#Preview {
    NavigationStack {
        CheckComputerView(computers: Computer.samples)
    }
}
