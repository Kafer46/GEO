import SwiftUI

struct TeacherListView: View {
    @Environment(SchoolController.self) private var controller

    var body: some View {
        NavigationStack {
            List(controller.teachers) { teacher in
                NavigationLink {
                    TeacherDetailView(teacher: teacher)
                } label: {
                    RecordRow(record: teacher, trailing: "\(teacher.subjectIDs.count)")
                }
            }
            .overlay {
                if controller.teachers.isEmpty {
                    ContentUnavailableView("No teachers yet", systemImage: "person.text.rectangle")
                }
            }
            .navigationTitle("Teachers")
        }
    }
}

struct TeacherDetailView: View {
    let teacher: Teacher

    @Environment(SchoolController.self) private var controller
    @State private var showAssignForm = false

    var body: some View {
        let assigned = controller.subjects(of: teacher)
        List {
            Section("Information") {
                LabeledContent("Teacher ID", value: teacher.id)
                LabeledContent("Name", value: teacher.name)
                LabeledContent("Email", value: teacher.email)
            }

            Section("Assigned subjects (\(assigned.count))") {
                if assigned.isEmpty {
                    Text("No subjects assigned yet.")
                        .foregroundStyle(.secondary)
                }
                ForEach(assigned) { subject in
                    RecordRow(record: subject)
                        .swipeActions {
                            Button("Remove", role: .destructive) {
                                controller.unassign(subjectID: subject.id, from: teacher.id)
                            }
                        }
                }
                Button {
                    showAssignForm = true
                } label: {
                    Label("Assign a subject", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle(teacher.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAssignForm) {
            AssignSubjectView(teacher: teacher)
        }
    }
}

struct AssignSubjectView: View {
    let teacher: Teacher

    @Environment(SchoolController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSubjectID = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Teacher") {
                    Text("\(teacher.name) (\(teacher.id))")
                }
                Section("Subject") {
                    Picker("Subject", selection: $selectedSubjectID) {
                        Text("Choose a subject").tag("")
                        ForEach(controller.subjects) { subject in
                            Text("\(subject.id) – \(subject.title)").tag(subject.id)
                        }
                    }
                }
                if errorMessage != nil {
                    Section {
                        ErrorText(message: errorMessage)
                    }
                }
            }
            .navigationTitle("Assign Subject")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Assign") { assign() }
                }
            }
        }
    }

    private func assign() {
        guard !selectedSubjectID.isEmpty else {
            errorMessage = SchoolError.emptyField("Subject").localizedDescription
            return
        }
        do {
            try controller.assign(subjectID: selectedSubjectID, to: teacher.id)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    TeacherListView()
        .environment(SchoolController.withSampleData())
}
