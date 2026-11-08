import Foundation

enum Validator {
    static func requireText(_ value: String, field: String) throws -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw SchoolError.emptyField(field) }
        return trimmed
    }

    static func requireEmail(_ value: String) throws -> String {
        let trimmed = try requireText(value, field: "Email")
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        guard trimmed.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil else {
            throw SchoolError.invalidEmail
        }
        return trimmed
    }

    static func requireMark(_ value: Double) throws -> Double {
        guard value.isFinite, (0...10).contains(value) else { throw SchoolError.invalidMark(value) }
        return value
    }

    static func requireAcademicYear(_ value: String) throws -> String {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        let parts = trimmed.split(separator: "-")
        guard parts.count == 2,
              let start = Int(parts[0]), let end = Int(parts[1]),
              parts[0].count == 4, end == start + 1 else {
            throw SchoolError.invalidAcademicYear
        }
        return trimmed
    }
}
