import SwiftUI

struct StudentDetailView: View {
    let student: Student

    @Environment(SchoolController.self) private var controller
    @State private var showEditForm = false
    @State private var showEnrollForm = false

    var body: some View {
        let studentEnrollments = controller.enrollments(of: student)
        List {
            Section("Information") {
                LabeledContent("Student ID", value: student.id)
                LabeledContent("Name", value: student.name)
                LabeledContent("Email", value: student.email)
                if let average = controller.averageMark(of: student) {
                    LabeledContent("Average mark", value: String(format: "%.2f", average))
                } else {
                    LabeledContent("Average mark", value: "No marks yet")
                }
            }

            Section("Subjects & marks (\(studentEnrollments.count))") {
                if studentEnrollments.isEmpty {
                    Text("This student is not enrolled in any subject.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(studentEnrollments) { enrollment in
                        NavigationLink {
                            MarkEditView(enrollment: enrollment)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(controller.subjectTitle(for: enrollment))
                                        .font(.headline)
                                    Text("\(enrollment.subjectID) · \(enrollment.academicYear)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                MarkBadge(enrollment: enrollment)
                            }
                        }
                    }
                }
                Button {
                    showEnrollForm = true
                } label: {
                    Label("Enroll in a subject", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle(student.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") { showEditForm = true }
        }
        .sheet(isPresented: $showEditForm) {
            StudentFormView(student: student)
        }
        .sheet(isPresented: $showEnrollForm) {
            EnrollmentFormView(preselectedStudentID: student.id)
        }
    }
}
