import Foundation

struct Student: Identifiable, Equatable {
    var id: String
    var name: String
    var gpa: Double

    static let samples: [Student] = [
        Student(id: "S001", name: "An", gpa: 8.5),
        Student(id: "S002", name: "Binh", gpa: 9.0),
        Student(id: "S003", name: "Chi", gpa: 7.8),
        Student(id: "S004", name: "Duy", gpa: 9.2),
        Student(id: "S005", name: "Lan", gpa: 8.0)
    ]
}
