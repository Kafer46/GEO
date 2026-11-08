import SwiftUI

struct EnrollmentFormView: View {
    @Environment(SchoolController.self) private var controller
    @Environment(\.dismiss) private var dismiss

    @State private var studentID: String
    @State private var subjectID = ""
    @State private var academicYear = "2026-2027"
    @State private var errorMessage: String?

    init(preselectedStudentID: String?) {
        _studentID = State(initialValue: preselectedStudentID ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Student") {
                    Picker("Student", selection: $studentID) {
                        Text("Choose a student").tag("")
                        ForEach(controller.students) { student in
                            Text("\(student.id) – \(student.name)").tag(student.id)
                        }
                    }
                }
                Section("Subject") {
                    Picker("Subject", selection: $subjectID) {
                        Text("Choose a subject").tag("")
                        ForEach(controller.subjects) { subject in
                            Text("\(subject.id) – \(subject.title)").tag(subject.id)
                        }
                    }
                }
                Section("Academic year") {
                    TextField("e.g. 2026-2027", text: $academicYear)
                        .keyboardType(.numbersAndPunctuation)
                }
                if errorMessage != nil {
                    Section {
                        ErrorText(message: errorMessage)
                    }
                }
            }
            .navigationTitle("Enroll Student")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enroll") { enroll() }
                }
            }
        }
    }

    private func enroll() {
        guard !studentID.isEmpty else {
            errorMessage = SchoolError.emptyField("Student").localizedDescription
            return
        }
        guard !subjectID.isEmpty else {
            errorMessage = SchoolError.emptyField("Subject").localizedDescription
            return
        }
        do {
            try controller.enroll(studentID: studentID, subjectID: subjectID, academicYear: academicYear)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    EnrollmentFormView(preselectedStudentID: "S001")
        .environment(SchoolController.withSampleData())
}
