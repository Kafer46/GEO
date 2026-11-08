import Foundation

enum SchoolError: LocalizedError, Equatable {
    case emptyField(String)
    case invalidEmail
    case invalidMark(Double)
    case invalidCredits
    case invalidSemester
    case invalidAcademicYear
    case duplicateID(String)
    case duplicateEnrollment
    case duplicateAssignment
    case notFound(String)

    var errorDescription: String? {
        switch self {
        case .emptyField(let field):
            return "\(field) is required."
        case .invalidEmail:
            return "Please enter a valid email (e.g. name@school.edu)."
        case .invalidMark:
            return "Mark must be a number from 0 to 10."
        case .invalidCredits:
            return "Credits must be greater than 0."
        case .invalidSemester:
            return "Semester must be 1, 2 or 3."
        case .invalidAcademicYear:
            return "Academic year must look like 2026-2027."
        case .duplicateID(let id):
            return "ID \(id) already exists."
        case .duplicateEnrollment:
            return "This student is already enrolled in this subject for this academic year."
        case .duplicateAssignment:
            return "This subject is already assigned to this teacher."
        case .notFound(let item):
            return "\(item) was not found."
        }
    }
}
