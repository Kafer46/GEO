//
//  ContentView.swift
//  FishStore
//
//  Created by MAY 07 on 5/10/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isGlowing = false

    private let oceanBlue = Color(red: 0.03, green: 0.24, blue: 0.43)
    private let aquaBlue = Color(red: 0.05, green: 0.58, blue: 0.69)

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("KAT")
                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                        .tracking(6)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [oceanBlue, aquaBlue, oceanBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: aquaBlue.opacity(isGlowing ? 0.30 : 0.10),
                            radius: isGlowing ? 14 : 5,
                            y: 3
                        )
                        .scaleEffect(isGlowing ? 1.025 : 1)
                        .animation(
                            reduceMotion ? nil : .easeInOut(duration: 2.2)
                                .repeatForever(autoreverses: true),
                            value: isGlowing
                        )

                    Text("Cá cảnh & phụ kiện")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(oceanBlue.opacity(0.75))
                }

                Image("FishStoreLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: min(max(geometry.size.width - 48, 0), 340),
                        height: min(max(geometry.size.height - 180, 0), 340)
                    )
                    .accessibilityLabel("FishStore — cửa hàng cá cảnh")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.white.ignoresSafeArea())
        .task(id: reduceMotion) {
            isGlowing = !reduceMotion
        }
    }
}

#Preview {
    ContentView()
}
