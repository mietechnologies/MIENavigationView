import SwiftUI

public struct MIENavigationView<Route: Identifiable & Hashable, Content: View>: View {
    private let backSwipeActivationEdgeWidth: CGFloat = 32
    private let backSwipeCompletionThreshold: CGFloat = 0.3

    @State private var ownedNavigator: MIENavigator<Route>
    private let externalNavigator: MIENavigator<Route>?
    private let content: (Route) -> Content

    @State private var titleView: EquatableViewBox?
    @State private var leadingView: EquatableViewBox?
    @State private var trailingView: EquatableViewBox?
    @State private var backgroundView: EquatableViewBox?
    @State private var backButtonColor: Color?
    @State private var dragOffset: CGFloat = 0
    @State private var isBackSwipeActive = false

    /// Creates a navigation view with an internal navigator rooted at the given route.
    public init(root: Route, @ViewBuilder content: @escaping (Route) -> Content) {
        _ownedNavigator = State(initialValue: MIENavigator(root: root))
        self.externalNavigator = nil
        self.content = content
    }

    /// Creates a navigation view using an externally-provided navigator.
    public init(navigator: MIENavigator<Route>, @ViewBuilder content: @escaping (Route) -> Content) {
        _ownedNavigator = State(initialValue: navigator)
        self.externalNavigator = navigator
        self.content = content
    }

    private var navigator: MIENavigator<Route> {
        externalNavigator ?? ownedNavigator
    }

    public var body: some View {
        VStack(spacing: 0) {
            MIENavigationBar(
                navigator: navigator,
                titleView: titleView,
                leadingView: leadingView,
                trailingView: trailingView,
                backgroundView: backgroundView,
                backButtonColor: backButtonColor
            )

            contentArea
        }
        .environment(navigator)
    }

    private var contentArea: some View {
        GeometryReader { geometry in
            scrollContent(in: geometry)
                .simultaneousGesture(backSwipeGesture(in: geometry))
        }
        .clipped()
    }

    private func scrollContent(in geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(navigator.stack.enumerated()), id: \.offset) { entry in
                let route = entry.element
                content(route)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .onPreferenceChange(MIENavigationTitleKey.self) { titleView = $0 }
        .onPreferenceChange(MIENavigationLeadingKey.self) { leadingView = $0 }
        .onPreferenceChange(MIENavigationTrailingKey.self) { trailingView = $0 }
        .onPreferenceChange(MIENavigationBarBackgroundKey.self) { backgroundView = $0 }
        .onPreferenceChange(MIENavigationBackButtonColorKey.self) { backButtonColor = $0 }
        .offset(x: -CGFloat(navigator.stack.count - 1) * geometry.size.width + dragOffset)
        .animation(.easeInOut(duration: 0.3), value: navigator.stack.count)
        .animation(.easeInOut(duration: 0.3), value: dragOffset == 0)
    }

    private func backSwipeGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                guard navigator.canGoBack else { return }

                if !isBackSwipeActive {
                    let isEdgeStart = value.startLocation.x <= backSwipeActivationEdgeWidth
                    let isHorizontalSwipe = abs(value.translation.width) > abs(value.translation.height)
                    guard isEdgeStart, isHorizontalSwipe else { return }
                    isBackSwipeActive = true
                }

                guard isBackSwipeActive else { return }
                dragOffset = min(max(0, value.translation.width), geometry.size.width)
            }
            .onEnded { _ in
                guard navigator.canGoBack, isBackSwipeActive else {
                    dragOffset = 0
                    isBackSwipeActive = false
                    return
                }

                if dragOffset > geometry.size.width * backSwipeCompletionThreshold {
                    navigator.pop()
                }

                dragOffset = 0
                isBackSwipeActive = false
            }
    }
}
