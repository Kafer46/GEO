import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            StudentListView()
                .tabItem { Label("Students", systemImage: "person.3.fill") }

            SubjectListView()
                .tabItem { Label("Subjects", systemImage: "books.vertical.fill") }

            TeacherListView()
                .tabItem { Label("Teachers", systemImage: "person.text.rectangle") }

            EnrollmentListView()
                .tabItem { Label("Enrollments", systemImage: "list.clipboard") }
        }
    }
}

#Preview {
    MainTabView()
        .environment(SchoolController.withSampleData())
}
