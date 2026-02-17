//
//  ContentView.swift
//  MIENavigationView Example
//
//  Created by Brett Chapin on 2026.02.16.
//

import SwiftUI
import MIENavigationView

// MARK: - Route Definition

enum AppRoute: Hashable, Identifiable {
    case home
    case detail(item: String)
    case settings
    case customBar

    var id: Self { self }
}

// MARK: - Root Content View

struct ContentView: View {
    var body: some View {
        MIENavigationView(root: AppRoute.home) { route in
            switch route {
            case .home:
                HomeView()
            case .detail(let item):
                DetailView(item: item)
            case .settings:
                SettingsView()
            case .customBar:
                CustomBarView()
            }
        }
    }
}

// MARK: - Home View

struct HomeView: View {
    @Environment(MIENavigator<AppRoute>.self) var navigator

    private let items = ["Sunset", "Mountain", "Ocean", "Forest", "Desert"]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(items, id: \.self) { item in
                    Button {
                        navigator.push(.detail(item: item))
                    } label: {
                        HStack {
                            Image(systemName: "photo")
                                .font(.title2)
                            Text(item)
                                .font(.body)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }

                Divider()
                    .padding(.vertical, 8)

                Button {
                    navigator.push(.settings)
                } label: {
                    HStack {
                        Image(systemName: "gear")
                            .font(.title2)
                        Text("Settings")
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)

                Button {
                    navigator.push(.customBar)
                } label: {
                    HStack {
                        Image(systemName: "paintbrush")
                            .font(.title2)
                        Text("Custom Navigation Bar")
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
        .mieNavigationTitle("Home")
    }
}

// MARK: - Detail View

struct DetailView: View {
    @Environment(MIENavigator<AppRoute>.self) var navigator

    let item: String

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "photo.artframe")
                .font(.system(size: 80))
                .foregroundStyle(.tint)

            Text(item)
                .font(.largeTitle.bold())

            Text("This view was pushed by navigating to `.detail(item: \"\(item)\")`.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Push Another Detail") {
                navigator.push(.detail(item: "\(item) ▸ Nested"))
            }
            .buttonStyle(.borderedProminent)

            Button("Pop to Root") {
                navigator.popToRoot()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .mieNavigationTitle(item)
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(MIENavigator<AppRoute>.self) var navigator

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "gear")
                .font(.system(size: 80))
                .foregroundStyle(.secondary)

            Text("Settings")
                .font(.largeTitle.bold())

            Text("This page demonstrates the `.mieNavigationTrailing` modifier to add a toolbar button.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Replace Root with Home") {
                navigator.replaceRoot(.home)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .mieNavigationTitle("Settings")
        .mieNavigationTrailing {
            Button {
                navigator.pop()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Custom Bar View

struct CustomBarView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 80))
                .foregroundStyle(.white)

            Text("Custom Navigation Bar")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("This page uses a gradient background, a custom styled title, and leading/trailing toolbar items.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .mieNavigationTitle(
            Text("Styled Title")
                .font(.title2.bold())
                .foregroundStyle(.white)
        )
        .mieNavigationBarBackground(
            LinearGradient(
                colors: [.purple, .blue],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .mieNavigationLeading {
            Button {
                // Custom leading action
            } label: {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .mieNavigationTrailing {
            Button {
                // Custom trailing action
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    ContentView()
}
