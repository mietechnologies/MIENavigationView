import SwiftUI

public struct MIENavigationView<Route: Identifiable & Hashable, Content: View>: View {
    @Bindable private var navigator: MIENavigator<Route>
    private let ownsNavigator: Bool
    private let content: (Route) -> Content

    @State private var titleView: EquatableViewBox?
    @State private var leadingView: EquatableViewBox?
    @State private var trailingView: EquatableViewBox?
    @State private var backgroundView: EquatableViewBox?
    @State private var backButtonColor: Color?
    @State private var dragOffset: CGFloat = 0

    /// Creates a navigation view with an internal navigator rooted at the given route.
    public init(root: Route, @ViewBuilder content: @escaping (Route) -> Content) {
        self.navigator = MIENavigator(root: root)
        self.ownsNavigator = true
        self.content = content
    }

    /// Creates a navigation view using an externally-provided navigator.
    public init(navigator: MIENavigator<Route>, @ViewBuilder content: @escaping (Route) -> Content) {
        self.navigator = navigator
        self.ownsNavigator = false
        self.content = content
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
                .gesture(backSwipeGesture(in: geometry))
        }
        .clipped()
    }

    private func scrollContent(in geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            ForEach(navigator.stack) { route in
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
        DragGesture()
            .onChanged { value in
                guard navigator.canGoBack, value.translation.width > 0 else { return }
                dragOffset = value.translation.width
            }
            .onEnded { value in
                guard navigator.canGoBack else { return }
                if value.translation.width > geometry.size.width * 0.3 {
                    navigator.pop()
                }
                dragOffset = 0
            }
    }
}
