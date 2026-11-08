import SwiftUI

struct RecordRow: View {
    let record: any Describable
    var trailing: String?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: record.symbolName)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(record.displayTitle)
                    .font(.headline)
                Text(record.displaySubtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let trailing {
                Text(trailing)
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct ErrorText: View {
    let message: String?

    var body: some View {
        if let message {
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }
}

struct MarkBadge: View {
    let enrollment: Enrollment

    private var color: Color {
        guard let mark = enrollment.mark else { return .gray }
        if mark >= 8 { return .green }
        if mark >= 5 { return .orange }
        return .red
    }

    var body: some View {
        Text(enrollment.markText)
            .font(.subheadline.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.12), in: Capsule())
    }
}
