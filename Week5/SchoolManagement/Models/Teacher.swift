import Foundation
import Observation

@Observable
final class Teacher: PersonRecord {
    let id: String
    private(set) var name: String
    private(set) var email: String
    private(set) var subjectIDs: Set<String> = []

    init(id: String, name: String, email: String) throws {
        self.id = try Validator.requireText(id, field: "Teacher ID").uppercased()
        self.name = try Validator.requireText(name, field: "Name")
        self.email = try Validator.requireEmail(email)
    }

    func assign(subjectID: String) throws {
        guard !subjectIDs.contains(subjectID) else { throw SchoolError.duplicateAssignment }
        subjectIDs.insert(subjectID)
    }

    func unassign(subjectID: String) {
        subjectIDs.remove(subjectID)
    }

    func teaches(subjectID: String) -> Bool {
        subjectIDs.contains(subjectID)
    }

    var symbolName: String { "person.text.rectangle.fill" }

    func describe() -> String {
        "Teacher \(id): \(name), teaches \(subjectIDs.count) subject(s)"
    }
}
