import SwiftUI

struct EnrollmentListView: View {
    @Environment(SchoolController.self) private var controller
    @State private var searchText = ""
    @State private var showEnrollForm = false

    private var filtered: [Enrollment] {
        let text = searchText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return controller.enrollments }
        return controller.enrollments.filter {
            $0.studentID.localizedCaseInsensitiveContains(text) ||
            $0.subjectID.localizedCaseInsensitiveContains(text) ||
            controller.studentName(for: $0).localizedCaseInsensitiveContains(text) ||
            controller.subjectTitle(for: $0).localizedCaseInsensitiveContains(text)
        }
    }

    var body: some View {
        NavigationStack {
            let results = filtered
            List {
                if results.isEmpty {
                    ContentUnavailableView("No enrollments found", systemImage: "list.clipboard")
                } else {
                    Section("\(results.count) enrollment(s)") {
                        ForEach(results) { enrollment in
                            NavigationLink {
                                MarkEditView(enrollment: enrollment)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(controller.studentName(for: enrollment))
                                            .font(.headline)
                                        Text("\(controller.subjectTitle(for: enrollment)) · \(enrollment.academicYear)")
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
            }
            .searchable(text: $searchText, prompt: "Search student or subject")
            .navigationTitle("Enrollments")
            .toolbar {
                Button {
                    showEnrollForm = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Enroll student")
            }
            .sheet(isPresented: $showEnrollForm) {
                EnrollmentFormView(preselectedStudentID: nil)
            }
        }
    }
}

#Preview {
    EnrollmentListView()
        .environment(SchoolController.withSampleData())
}
