import Foundation
import Observation

@Observable
final class Student: PersonRecord {
    let id: String
    private(set) var name: String
    private(set) var email: String

    init(id: String, name: String, email: String) throws {
        self.id = try Validator.requireText(id, field: "Student ID").uppercased()
        self.name = try Validator.requireText(name, field: "Name")
        self.email = try Validator.requireEmail(email)
    }

    func update(name: String, email: String) throws {
        let validName = try Validator.requireText(name, field: "Name")
        let validEmail = try Validator.requireEmail(email)
        self.name = validName
        self.email = validEmail
    }

    var symbolName: String { "person.crop.circle.fill" }

    func describe() -> String {
        "Student \(id): \(name) <\(email)>"
    }
}
