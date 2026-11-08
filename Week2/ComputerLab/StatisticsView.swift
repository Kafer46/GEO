import SwiftUI

struct StatisticsView: View {
    let computers: [Computer]

    private var availableCount: Int {
        computers.filter { $0.isAvailable }.count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.orange)

                HStack(spacing: 12) {
                    StatCard(title: "Total", value: computers.count, color: .blue)
                    StatCard(title: "Available", value: availableCount, color: .green)
                    StatCard(title: "In Use", value: computers.count - availableCount, color: .red)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Computer List")
                        .font(.headline)
                    ForEach(computers) { computer in
                        HStack {
                            Image(systemName: "desktopcomputer")
                                .foregroundStyle(.blue)
                            VStack(alignment: .leading) {
                                Text(computer.name)
                                Text(computer.location)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            StatusBadge(isAvailable: computer.isAvailable)
                        }
                        Divider()
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCard: View {
    let title: String
    let value: Int
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        StatisticsView(computers: Computer.samples)
    }
}
