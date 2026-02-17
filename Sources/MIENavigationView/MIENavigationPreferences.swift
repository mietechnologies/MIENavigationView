import SwiftUI

struct EquatableViewBox: Equatable {
    let id = UUID()
    let view: AnyView

    static func == (lhs: EquatableViewBox, rhs: EquatableViewBox) -> Bool {
        lhs.id == rhs.id
    }
}

struct MIENavigationTitleKey: PreferenceKey {
    static var defaultValue: EquatableViewBox? = nil

    static func reduce(value: inout EquatableViewBox?, nextValue: () -> EquatableViewBox?) {
        if let next = nextValue() {
            value = next
        }
    }
}

struct MIENavigationLeadingKey: PreferenceKey {
    static var defaultValue: EquatableViewBox? = nil

    static func reduce(value: inout EquatableViewBox?, nextValue: () -> EquatableViewBox?) {
        if let next = nextValue() {
            value = next
        }
    }
}

struct MIENavigationTrailingKey: PreferenceKey {
    static var defaultValue: EquatableViewBox? = nil

    static func reduce(value: inout EquatableViewBox?, nextValue: () -> EquatableViewBox?) {
        if let next = nextValue() {
            value = next
        }
    }
}

struct MIENavigationBarBackgroundKey: PreferenceKey {
    static var defaultValue: EquatableViewBox? = nil

    static func reduce(value: inout EquatableViewBox?, nextValue: () -> EquatableViewBox?) {
        if let next = nextValue() {
            value = next
        }
    }
}
