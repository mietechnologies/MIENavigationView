import XCTest
@testable import MIENavigationView

private enum TestRoute: Hashable, Identifiable {
    case home
    case detail(String)
    case settings

    var id: Self { self }
}

@MainActor
final class MIENavigatorTests: XCTestCase {
    func testStartsWithRootRoute() {
        let navigator = MIENavigator(root: TestRoute.home)

        XCTAssertEqual(navigator.stack, [.home])
        XCTAssertEqual(navigator.currentRoute, .home)
        XCTAssertFalse(navigator.canGoBack)
    }

    func testPushAndPop() {
        let navigator = MIENavigator<TestRoute>(root: .home)
        navigator.push(.detail("one"))
        navigator.push(.settings)

        XCTAssertEqual(navigator.stack, [.home, .detail("one"), .settings])
        XCTAssertEqual(navigator.currentRoute, .settings)
        XCTAssertTrue(navigator.canGoBack)

        navigator.pop()

        XCTAssertEqual(navigator.stack, [.home, .detail("one")])
        XCTAssertEqual(navigator.currentRoute, .detail("one"))
    }

    func testPopAtRootIsNoOp() {
        let navigator = MIENavigator<TestRoute>(root: .home)

        navigator.pop()

        XCTAssertEqual(navigator.stack, [.home])
        XCTAssertEqual(navigator.currentRoute, .home)
    }

    func testPopToRoot() {
        let navigator = MIENavigator<TestRoute>(root: .home)
        navigator.push(.detail("one"))
        navigator.push(.settings)

        navigator.popToRoot()

        XCTAssertEqual(navigator.stack, [.home])
        XCTAssertEqual(navigator.currentRoute, .home)
        XCTAssertFalse(navigator.canGoBack)
    }

    func testReplaceRootResetsStack() {
        let navigator = MIENavigator<TestRoute>(root: .home)
        navigator.push(.detail("one"))

        navigator.replaceRoot(.settings)

        XCTAssertEqual(navigator.stack, [.settings])
        XCTAssertEqual(navigator.currentRoute, .settings)
        XCTAssertFalse(navigator.canGoBack)
    }

    func testReplaceStackRejectsEmptyInput() {
        let navigator = MIENavigator<TestRoute>(root: .home)
        navigator.push(.detail("one"))

        navigator.replaceStack([])

        XCTAssertEqual(navigator.stack, [.home, .detail("one")])
    }

    func testReplaceStackAcceptsNonEmptyInput() {
        let navigator = MIENavigator<TestRoute>(root: .home)

        navigator.replaceStack([.settings, .detail("two")])

        XCTAssertEqual(navigator.stack, [.settings, .detail("two")])
        XCTAssertEqual(navigator.currentRoute, .detail("two"))
        XCTAssertTrue(navigator.canGoBack)
    }
}
