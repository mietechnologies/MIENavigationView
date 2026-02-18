import SwiftUI

private let navBarButtonSize: CGFloat = 25

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

            HStack {
                leadingContent
                Spacer()
                if let titleView { titleView.view }
                Spacer()
                trailingContent
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
                    .frame(width: navBarButtonSize, height: navBarButtonSize)
                    .foregroundStyle(backButtonColor ?? .accentColor)
            }
        } else if let leadingView {
            leadingView.view
                .frame(minWidth: navBarButtonSize, minHeight: navBarButtonSize)
        } else {
            Color.clear.frame(width: 0)
        }
    }

    @ViewBuilder
    private var trailingContent: some View {
        if let trailingView {
            trailingView.view
                .frame(minWidth: navBarButtonSize, minHeight: navBarButtonSize)
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
