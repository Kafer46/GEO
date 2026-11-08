import SwiftUI

struct ComputerLabView: View {
    @State private var computers: [Computer] = Computer.samples

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Image(systemName: "desktopcomputer")
                        .font(.system(size: 40))
                        .foregroundStyle(.blue)
                    Text("Computer Lab")
                        .font(.title.bold())
                    Text("Manage computers easily")
                        .foregroundStyle(.secondary)
                }

                List {
                    ForEach($computers) { $computer in
                        ComputerRow(computer: computer)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                computer.isAvailable.toggle()
                            }
                    }
                    .onDelete { offsets in
                        computers.remove(atOffsets: offsets)
                    }
                }
                .listStyle(.plain)

                HStack(spacing: 10) {
                    NavigationLink {
                        CheckComputerView(computers: computers)
                    } label: {
                        Label("Check", systemImage: "magnifyingglass")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    NavigationLink {
                        StatisticsView(computers: computers)
                    } label: {
                        Label("Statistics", systemImage: "chart.bar.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)

                NavigationLink {
                    AddComputerView(computers: $computers)
                } label: {
                    Label("Add Computer", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)

                Text("Total computers: \(computers.count)")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .toolbar {
                EditButton()
            }
        }
    }
}

struct ComputerRow: View {
    let computer: Computer

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "desktopcomputer")
                .font(.title2)
                .foregroundStyle(.blue)
            VStack(alignment: .leading) {
                Text(computer.name)
                    .font(.headline)
                Text(computer.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            StatusBadge(isAvailable: computer.isAvailable)
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let isAvailable: Bool

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isAvailable ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            Text(isAvailable ? "Available" : "In Use")
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((isAvailable ? Color.green : Color.red).opacity(0.12), in: Capsule())
    }
}

#Preview {
    ComputerLabView()
}
