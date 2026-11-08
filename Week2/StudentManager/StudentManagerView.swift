import SwiftUI

struct StudentManagerView: View {
    @State private var students: [Student] = Student.samples
    @State private var searchText = ""
    @State private var onlyGoodStudents = false
    @State private var sortByGPA = false
    @State private var showAddStudent = false
    @State private var editingStudent: Student?

    private var displayedStudents: [Student] {
        var result = students
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.id.localizedCaseInsensitiveContains(searchText)
            }
        }
        if onlyGoodStudents {
            result = result.filter { $0.gpa >= 8.0 }
        }
        if sortByGPA {
            result.sort { $0.gpa > $1.gpa }
        }
        return result
    }

    private var topStudent: Student? {
        students.max { $0.gpa < $1.gpa }
    }

    private var averageGPA: Double {
        guard !students.isEmpty else { return 0 }
        return students.reduce(0) { $0 + $1.gpa } / Double(students.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                VStack(spacing: 4) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(.blue)
                    Text("Student Manager")
                        .font(.title.bold())
                    Text("A better class, a brighter tomorrow")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search student by name or id...", text: $searchText)
                }
                .padding(10)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

                HStack {
                    Toggle("GPA ≥ 8.0", isOn: $onlyGoodStudents)
                        .toggleStyle(.button)
                    Toggle("Sort by GPA", isOn: $sortByGPA)
                        .toggleStyle(.button)
                    Spacer()
                }
                .font(.footnote)
                .padding(.horizontal)

                if let topStudent {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(.yellow)
                        Text("Highest GPA: \(topStudent.name) (\(topStudent.id)) – \(topStudent.gpa, specifier: "%.1f")")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal)
                }

                if displayedStudents.isEmpty {
                    ContentUnavailableView("No students found", systemImage: "person.crop.circle.badge.questionmark")
                } else {
                    List {
                        ForEach(displayedStudents) { student in
                            Button {
                                editingStudent = student
                            } label: {
                                StudentRow(student: student, isTop: student.id == topStudent?.id)
                            }
                            .foregroundStyle(.primary)
                            .swipeActions {
                                Button(role: .destructive) {
                                    removeStudent(id: student.id)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                Button {
                    showAddStudent = true
                } label: {
                    Label("Add Student", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)

                Text("Total students: \(students.count) · Average GPA: \(averageGPA, specifier: "%.2f")")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .sheet(isPresented: $showAddStudent) {
                StudentFormView(student: nil, existingIds: students.map(\.id)) { newStudent in
                    students.append(newStudent)
                }
            }
            .sheet(item: $editingStudent) { student in
                StudentFormView(student: student, existingIds: students.map(\.id)) { updated in
                    if let index = students.firstIndex(where: { $0.id == student.id }) {
                        students[index] = updated
                    }
                }
            }
        }
    }

    private func removeStudent(id: String) {
        students.removeAll { $0.id == id }
    }
}

struct StudentRow: View {
    let student: Student
    let isTop: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundStyle(.blue)
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text(student.name)
                        .font(.headline)
                    if isTop {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
                Text(student.id)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("GPA: \(student.gpa, specifier: "%.1f")")
                .font(.subheadline.bold())
                .foregroundStyle(student.gpa >= 8.0 ? .green : .orange)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StudentManagerView()
}
