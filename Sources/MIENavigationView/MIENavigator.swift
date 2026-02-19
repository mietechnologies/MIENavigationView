import SwiftUI

@Observable
public final class MIENavigator<Route: Identifiable & Hashable> {
    public private(set) var stack: [Route]

    public var canGoBack: Bool {
        stack.count > 1
    }

    public var currentRoute: Route {
        stack[stack.count - 1]
    }

    public init(root: Route) {
        self.stack = [root]
    }

    public func push(_ route: Route) {
        stack.append(route)
    }

    public func pop() {
        guard canGoBack else { return }
        stack.removeLast()
    }

    public func popToRoot() {
        guard canGoBack else { return }
        stack = [stack[0]]
    }

    public func replaceRoot(_ route: Route) {
        stack = [route]
    }

    public func replaceStack(_ routes: [Route]) {
        guard !routes.isEmpty else { return }
        stack = routes
    }
}
