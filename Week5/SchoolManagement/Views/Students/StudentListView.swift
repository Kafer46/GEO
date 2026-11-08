import SwiftUI

struct StudentListView: View {
    @Environment(SchoolController.self) private var controller
    @State private var searchText = ""
    @State private var showAddForm = false

    var body: some View {
        NavigationStack {
            let results = controller.searchStudents(searchText)
            List {
                if results.isEmpty {
                    ContentUnavailableView(searchText.isEmpty ? "No students yet" : "No matching students",
                                           systemImage: "person.crop.circle.badge.questionmark")
                } else {
                    Section("\(results.count) student(s)") {
                        ForEach(results) { student in
                            NavigationLink {
                                StudentDetailView(student: student)
                            } label: {
                                RecordRow(record: student)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search by ID or name")
            .navigationTitle("Students")
            .toolbar {
                Button {
                    showAddForm = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add student")
            }
            .sheet(isPresented: $showAddForm) {
                StudentFormView(student: nil)
            }
        }
    }
}

#Preview {
    StudentListView()
        .environment(SchoolController.withSampleData())
}
