import SwiftUI

struct AddComputerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var computers: [Computer]

    @State private var computerName = ""
    @State private var location = ""
    @State private var isAvailable = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "desktopcomputer")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            TextField("Enter computer name (e.g. PC06)", text: $computerName)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.characters)

            TextField("Enter location (e.g. Lab A)", text: $location)
                .textFieldStyle(.roundedBorder)

            Toggle("Available", isOn: $isAvailable)

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Button {
                addComputer()
            } label: {
                Text("Add")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
        .padding()
        .navigationTitle("Add Computer")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addComputer() {
        let name = computerName.trimmingCharacters(in: .whitespaces).uppercased()
        let room = location.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty else {
            errorMessage = "Please enter a computer name."
            return
        }
        guard !computers.contains(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) else {
            errorMessage = "\(name) is already in the lab."
            return
        }

        computers.append(Computer(name: name, location: room.isEmpty ? "Unknown" : room, isAvailable: isAvailable))
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddComputerView(computers: .constant(Computer.samples))
    }
}
