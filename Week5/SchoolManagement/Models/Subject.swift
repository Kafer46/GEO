import Foundation
import Observation

@Observable
final class Subject: Describable, Identifiable {
    let id: String
    private(set) var title: String
    private(set) var credits: Int
    private(set) var semester: Int

    init(id: String, title: String, credits: Int, semester: Int) throws {
        self.id = try Validator.requireText(id, field: "Subject ID").uppercased()
        self.title = try Validator.requireText(title, field: "Title")
        guard credits > 0 else { throw SchoolError.invalidCredits }
        guard (1...3).contains(semester) else { throw SchoolError.invalidSemester }
        self.credits = credits
        self.semester = semester
    }

    func updateCredits(_ value: Int) throws {
        guard value > 0 else { throw SchoolError.invalidCredits }
        credits = value
    }

    var displayTitle: String { title }
    var displaySubtitle: String { "\(id) · \(credits) credits · Semester \(semester)" }
    var symbolName: String { "book.closed.fill" }

    func describe() -> String {
        "Subject \(id): \(title) (\(credits) credits, semester \(semester))"
    }
}
