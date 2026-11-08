import SwiftUI

struct MarkEditView: View {
    let enrollment: Enrollment

    @Environment(SchoolController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    @State private var markText: String
    @State private var errorMessage: String?

    init(enrollment: Enrollment) {
        self.enrollment = enrollment
        _markText = State(initialValue: enrollment.mark.map { String(format: "%.1f", $0) } ?? "")
    }

    var body: some View {
        Form {
            Section("Enrollment") {
                LabeledContent("Student", value: "\(controller.studentName(for: enrollment)) (\(enrollment.studentID))")
                LabeledContent("Subject", value: "\(controller.subjectTitle(for: enrollment)) (\(enrollment.subjectID))")
                LabeledContent("Academic year", value: enrollment.academicYear)
                LabeledContent("Current mark", value: enrollment.markText)
            }

            Section("New mark (0 – 10)") {
                TextField("e.g. 8.5", text: $markText)
                    .keyboardType(.decimalPad)
                ErrorText(message: errorMessage)
            }

            Section {
                Button("Save Mark") { save() }
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Update Mark")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func save() {
        do {
            try controller.updateMark(enrollmentID: enrollment.id, markText: markText)
            errorMessage = nil
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
