import Foundation
import Observation

@Observable
final class Enrollment: Identifiable {
    let id: UUID
    let studentID: String
    let subjectID: String
    let academicYear: String
    private(set) var mark: Double?

    init(id: UUID = UUID(), studentID: String, subjectID: String, academicYear: String, mark: Double? = nil) throws {
        self.id = id
        self.studentID = studentID
        self.subjectID = subjectID
        self.academicYear = try Validator.requireAcademicYear(academicYear)
        if let mark {
            self.mark = try Validator.requireMark(mark)
        } else {
            self.mark = nil
        }
    }

    func updateMark(_ value: Double) throws {
        mark = try Validator.requireMark(value)
    }

    func matches(studentID: String, subjectID: String, academicYear: String) -> Bool {
        self.studentID == studentID && self.subjectID == subjectID && self.academicYear == academicYear
    }

    var markText: String {
        guard let mark else { return "Not graded" }
        return String(format: "%.1f", mark)
    }
}
