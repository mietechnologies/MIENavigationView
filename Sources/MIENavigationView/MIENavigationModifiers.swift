import SwiftUI

// MARK: - Title Modifiers

struct MIENavigationTitleModifier: ViewModifier {
    let box: EquatableViewBox

    func body(content: Content) -> some View {
        content.preference(key: MIENavigationTitleKey.self, value: box)
    }
}

extension View {
    public func mieNavigationTitle<V: View>(_ title: V) -> some View {
        modifier(MIENavigationTitleModifier(box: EquatableViewBox(view: AnyView(title))))
    }

    public func mieNavigationTitle(_ title: String) -> some View {
        mieNavigationTitle(Text(title).font(.headline))
    }
}

// MARK: - Leading Toolbar Modifier

struct MIENavigationLeadingModifier: ViewModifier {
    let box: EquatableViewBox

    func body(content: Content) -> some View {
        content.preference(key: MIENavigationLeadingKey.self, value: box)
    }
}

extension View {
    public func mieNavigationLeading<V: View>(@ViewBuilder _ leading: () -> V) -> some View {
        modifier(MIENavigationLeadingModifier(box: EquatableViewBox(view: AnyView(leading()))))
    }
}

// MARK: - Trailing Toolbar Modifier

struct MIENavigationTrailingModifier: ViewModifier {
    let box: EquatableViewBox

    func body(content: Content) -> some View {
        content.preference(key: MIENavigationTrailingKey.self, value: box)
    }
}

extension View {
    public func mieNavigationTrailing<V: View>(@ViewBuilder _ trailing: () -> V) -> some View {
        modifier(MIENavigationTrailingModifier(box: EquatableViewBox(view: AnyView(trailing()))))
    }
}

// MARK: - Bar Background Modifier

struct MIENavigationBarBackgroundModifier: ViewModifier {
    let box: EquatableViewBox

    func body(content: Content) -> some View {
        content.preference(key: MIENavigationBarBackgroundKey.self, value: box)
    }
}

extension View {
    public func mieNavigationBarBackground<V: View>(_ background: V) -> some View {
        modifier(MIENavigationBarBackgroundModifier(box: EquatableViewBox(view: AnyView(background))))
    }

    public func mieNavigationBarBackground(_ material: Material) -> some View {
        mieNavigationBarBackground(Rectangle().fill(material))
    }
}
