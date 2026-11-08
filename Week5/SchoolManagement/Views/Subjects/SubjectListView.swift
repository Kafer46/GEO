import SwiftUI

struct SubjectListView: View {
    @Environment(SchoolController.self) private var controller

    var body: some View {
        NavigationStack {
            List(controller.subjects) { subject in
                NavigationLink {
                    SubjectDetailView(subject: subject)
                } label: {
                    RecordRow(record: subject, trailing: "\(controller.enrollments(of: subject).count)")
                }
            }
            .overlay {
                if controller.subjects.isEmpty {
                    ContentUnavailableView("No subjects yet", systemImage: "book.closed")
                }
            }
            .navigationTitle("Subjects")
        }
    }
}

struct SubjectDetailView: View {
    let subject: Subject

    @Environment(SchoolController.self) private var controller

    var body: some View {
        let subjectEnrollments = controller.enrollments(of: subject)
        let subjectTeachers = controller.teachers(of: subject)
        List {
            Section("Information") {
                LabeledContent("Subject ID", value: subject.id)
                LabeledContent("Title", value: subject.title)
                LabeledContent("Credits", value: "\(subject.credits)")
                LabeledContent("Semester", value: "\(subject.semester)")
            }

            Section("Teachers (\(subjectTeachers.count))") {
                if subjectTeachers.isEmpty {
                    Text("No teacher assigned yet.")
                        .foregroundStyle(.secondary)
                }
                ForEach(subjectTeachers) { teacher in
                    RecordRow(record: teacher)
                }
            }

            Section("Enrolled students (\(subjectEnrollments.count))") {
                ForEach(subjectEnrollments) { enrollment in
                    NavigationLink {
                        MarkEditView(enrollment: enrollment)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(controller.studentName(for: enrollment))
                                Text("\(enrollment.studentID) · \(enrollment.academicYear)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            MarkBadge(enrollment: enrollment)
                        }
                    }
                }
            }
        }
        .navigationTitle(subject.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SubjectListView()
        .environment(SchoolController.withSampleData())
}
