import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String
    var valueColor: Color = .primary

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(title)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
                    .fontWeight(.medium)
                    .foregroundStyle(valueColor)
                    .multilineTextAlignment(.trailing)
            }
            Divider()
        }
    }
}

#Preview {
    InfoRow(title: "Latitude", value: "10.8506")
        .padding()
}
