import SwiftUI
import XCTest
@testable import MIENavigationView

final class MIENavigationPreferenceKeyTests: XCTestCase {
    func testTitlePreferenceCanBeOverwrittenAndCleared() {
        let first = EquatableViewBox(view: AnyView(Text("First")))
        let second = EquatableViewBox(view: AnyView(Text("Second")))
        var value: EquatableViewBox? = first

        MIENavigationTitleKey.reduce(value: &value) { second }
        XCTAssertEqual(value, second)

        MIENavigationTitleKey.reduce(value: &value) { nil }
        XCTAssertNil(value)
    }

    func testBackButtonColorPreferenceCanBeCleared() {
        var value: Color? = .red

        MIENavigationBackButtonColorKey.reduce(value: &value) { nil }

        XCTAssertNil(value)
    }
}
