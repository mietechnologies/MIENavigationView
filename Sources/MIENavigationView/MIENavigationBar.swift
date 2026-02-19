import SwiftUI

private let navBarIconSize: CGFloat = 25
private let navBarTapTargetSize: CGFloat = 44

struct MIENavigationBar<Route: Identifiable & Hashable>: View {
    let navigator: MIENavigator<Route>
    let titleView: EquatableViewBox?
    let leadingView: EquatableViewBox?
    let trailingView: EquatableViewBox?
    let backgroundView: EquatableViewBox?
    let backButtonColor: Color?

    var body: some View {
        ZStack {
            if let backgroundView {
                backgroundView.view
                    .ignoresSafeArea(edges: .top)
            } else {
                defaultBackground
                    .ignoresSafeArea(edges: .top)
            }

            ZStack {
                if let titleView {
                    titleView.view
                        .frame(maxWidth: .infinity)
                }

                HStack {
                    leadingContent
                    Spacer()
                    trailingContent
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private var leadingContent: some View {
        if navigator.canGoBack {
            Button {
                navigator.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: navBarIconSize, height: navBarIconSize)
                    .foregroundStyle(backButtonColor ?? .accentColor)
            }
            .buttonStyle(.plain)
            .frame(width: navBarTapTargetSize, height: navBarTapTargetSize, alignment: .leading)
            .contentShape(Rectangle())
            .accessibilityLabel("Back")
            .accessibilityHint("Returns to the previous screen")
        } else if let leadingView {
            leadingView.view
                .frame(minWidth: navBarTapTargetSize, minHeight: navBarTapTargetSize)
        } else {
            Color.clear.frame(width: 0)
        }
    }

    @ViewBuilder
    private var trailingContent: some View {
        if let trailingView {
            trailingView.view
                .frame(minWidth: navBarTapTargetSize, minHeight: navBarTapTargetSize)
        } else {
            Color.clear.frame(width: 0)
        }
    }

    private var defaultBackground: some View {
        #if canImport(UIKit)
        Color(UIColor.systemBackground)
        #else
        Color(NSColor.windowBackgroundColor)
        #endif
    }
}
