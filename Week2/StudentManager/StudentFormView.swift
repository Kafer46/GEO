import SwiftUI

struct StudentFormView: View {
    let originalStudent: Student?
    let existingIds: [String]
    let onSave: (Student) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var id: String
    @State private var name: String
    @State private var gpa: String
    @State private var errorMessage: String?

    init(student: Student?, existingIds: [String], onSave: @escaping (Student) -> Void) {
        self.originalStudent = student
        self.existingIds = existingIds
        self.onSave = onSave
        _id = State(initialValue: student?.id ?? "")
        _name = State(initialValue: student?.name ?? "")
        _gpa = State(initialValue: student.map { String($0.gpa) } ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Student Information") {
                    TextField("Id (e.g. S006)", text: $id)
                        .textInputAutocapitalization(.characters)
                        .disabled(originalStudent != nil)
                    TextField("Name", text: $name)
                    TextField("GPA (0 – 10)", text: $gpa)
                        .keyboardType(.decimalPad)
                }

                if let errorMessage {
                    Section {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(originalStudent == nil ? "Add Student" : "Edit Student")
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
        let trimmedId = id.trimmingCharacters(in: .whitespaces).uppercased()
        let trimmedName = name.trimmingCharacters(in: .whitespaces)

        guard !trimmedId.isEmpty else {
            errorMessage = "Please enter a student id."
            return
        }
        if originalStudent == nil && existingIds.contains(where: { $0.caseInsensitiveCompare(trimmedId) == .orderedSame }) {
            errorMessage = "Id \(trimmedId) already exists."
            return
        }
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a student name."
            return
        }
        guard let value = Double(gpa.replacingOccurrences(of: ",", with: ".")), (0...10).contains(value) else {
            errorMessage = "GPA must be a number from 0 to 10."
            return
        }

        onSave(Student(id: trimmedId, name: trimmedName, gpa: value))
        dismiss()
    }
}

#Preview {
    StudentFormView(student: nil, existingIds: []) { _ in }
}
