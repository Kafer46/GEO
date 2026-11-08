import Foundation
import Observation

@Observable
final class SchoolController {
    private(set) var students: [Student] = []
    private(set) var teachers: [Teacher] = []
    private(set) var subjects: [Subject] = []
    private(set) var enrollments: [Enrollment] = []

    let currentAcademicYear = "2026-2027"

    init(students: [Student] = [], teachers: [Teacher] = [], subjects: [Subject] = [], enrollments: [Enrollment] = []) {
        self.students = students
        self.teachers = teachers
        self.subjects = subjects
        self.enrollments = enrollments
    }

    static func withSampleData() -> SchoolController {
        let data = SampleData.make()
        return SchoolController(students: data.students, teachers: data.teachers,
                                subjects: data.subjects, enrollments: data.enrollments)
    }

    func student(id: String) -> Student? {
        students.first { $0.id == id }
    }

    func subject(id: String) -> Subject? {
        subjects.first { $0.id == id }
    }

    func teacher(id: String) -> Teacher? {
        teachers.first { $0.id == id }
    }

    func searchStudents(_ query: String) -> [Student] {
        let text = query.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return students }
        return students.filter {
            $0.id.localizedCaseInsensitiveContains(text) || $0.name.localizedCaseInsensitiveContains(text)
        }
    }

    @discardableResult
    func addStudent(id: String, name: String, email: String) throws -> Student {
        let newStudent = try Student(id: id, name: name, email: email)
        guard student(id: newStudent.id) == nil else { throw SchoolError.duplicateID(newStudent.id) }
        students.append(newStudent)
        students.sort { $0.id < $1.id }
        return newStudent
    }

    func updateStudent(_ student: Student, name: String, email: String) throws {
        try student.update(name: name, email: email)
    }

    func assign(subjectID: String, to teacherID: String) throws {
        guard let teacher = self.teacher(id: teacherID) else { throw SchoolError.notFound("Teacher") }
        guard self.subject(id: subjectID) != nil else { throw SchoolError.notFound("Subject") }
        try teacher.assign(subjectID: subjectID)
    }

    func unassign(subjectID: String, from teacherID: String) {
        teacher(id: teacherID)?.unassign(subjectID: subjectID)
    }

    func subjects(of teacher: Teacher) -> [Subject] {
        subjects.filter { teacher.teaches(subjectID: $0.id) }
    }

    func teachers(of subject: Subject) -> [Teacher] {
        teachers.filter { $0.teaches(subjectID: subject.id) }
    }

    @discardableResult
    func enroll(studentID: String, subjectID: String, academicYear: String) throws -> Enrollment {
        guard student(id: studentID) != nil else { throw SchoolError.notFound("Student") }
        guard self.subject(id: subjectID) != nil else { throw SchoolError.notFound("Subject") }
        let year = try Validator.requireAcademicYear(academicYear)
        guard !enrollments.contains(where: { $0.matches(studentID: studentID, subjectID: subjectID, academicYear: year) }) else {
            throw SchoolError.duplicateEnrollment
        }
        let enrollment = try Enrollment(studentID: studentID, subjectID: subjectID, academicYear: year)
        enrollments.append(enrollment)
        return enrollment
    }

    func updateMark(enrollmentID: UUID, markText: String) throws {
        guard let enrollment = enrollments.first(where: { $0.id == enrollmentID }) else {
            throw SchoolError.notFound("Enrollment")
        }
        let normalized = markText.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")
        guard !normalized.isEmpty else { throw SchoolError.emptyField("Mark") }
        guard let value = Double(normalized) else { throw SchoolError.invalidMark(.nan) }
        try enrollment.updateMark(value)
    }

    func enrollments(of student: Student) -> [Enrollment] {
        enrollments.filter { $0.studentID == student.id }
    }

    func enrollments(of subject: Subject) -> [Enrollment] {
        enrollments.filter { $0.subjectID == subject.id }
    }

    func averageMark(of student: Student) -> Double? {
        let marks = enrollments(of: student).compactMap(\.mark)
        guard !marks.isEmpty else { return nil }
        return marks.reduce(0, +) / Double(marks.count)
    }

    func studentName(for enrollment: Enrollment) -> String {
        student(id: enrollment.studentID)?.name ?? enrollment.studentID
    }

    func subjectTitle(for enrollment: Enrollment) -> String {
        subject(id: enrollment.subjectID)?.title ?? enrollment.subjectID
    }
}
