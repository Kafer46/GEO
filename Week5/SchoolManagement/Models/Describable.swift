import Foundation

protocol Describable {
    var displayTitle: String { get }
    var displaySubtitle: String { get }
    var symbolName: String { get }
    func describe() -> String
}

protocol PersonRecord: Describable, Identifiable {
    var id: String { get }
    var name: String { get }
    var email: String { get }
}

extension PersonRecord {
    var displayTitle: String { name }
    var displaySubtitle: String { "\(id) · \(email)" }
}
