import SwiftUI

struct StudentFormView: View {
    let student: Student?

    @Environment(SchoolController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    @State private var studentID: String
    @State private var name: String
    @State private var email: String
    @State private var errorMessage: String?

    init(student: Student?) {
        self.student = student
        _studentID = State(initialValue: student?.id ?? "")
        _name = State(initialValue: student?.name ?? "")
        _email = State(initialValue: student?.email ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Student") {
                    TextField("Student ID (e.g. S026)", text: $studentID)
                        .textInputAutocapitalization(.characters)
                        .disabled(student != nil)
                    TextField("Full name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                if errorMessage != nil {
                    Section {
                        ErrorText(message: errorMessage)
                    }
                }
            }
            .navigationTitle(student == nil ? "Add Student" : "Edit Student")
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
        do {
            if let student {
                try controller.updateStudent(student, name: name, email: email)
            } else {
                try controller.addStudent(id: studentID, name: name, email: email)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    StudentFormView(student: nil)
        .environment(SchoolController.withSampleData())
}
