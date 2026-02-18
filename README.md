# MIENavigationView

A custom SwiftUI navigation container that replaces `NavigationStack` with horizontal sliding page transitions, an automatic back button, and fully customizable navigation bar content.

## Requirements

- iOS 17+ / macOS 14+
- Swift 5.9+

## Installation

Add the package to your Xcode project via **File > Add Package Dependencies**, or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/<your-org>/MIENavigationView.git", from: "1.0.0")
]
```

## Quick Start

### 1. Define Your Routes

Routes must conform to `Identifiable` and `Hashable`:

```swift
enum AppRoute: Hashable, Identifiable {
    case home
    case detail(item: String)
    case settings

    var id: Self { self }
}
```

### 2. Create the Navigation View

```swift
import MIENavigationView

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
            }
        }
    }
}
```

### 3. Push and Pop from Child Views

Child views access the navigator through the environment:

```swift
struct HomeView: View {
    @Environment(MIENavigator<AppRoute>.self) var navigator

    var body: some View {
        VStack {
            Button("Open Detail") {
                navigator.push(.detail(item: "Example"))
            }
            Button("Settings") {
                navigator.push(.settings)
            }
        }
        .mieNavigationTitle("Home")
    }
}
```

## API Reference

### MIENavigator

The `@Observable` class that manages the navigation stack.

```swift
let navigator = MIENavigator(root: AppRoute.home)

navigator.push(.detail(item: "id"))   // Push a new route
navigator.pop()                        // Go back one level
navigator.popToRoot()                  // Return to the root route
navigator.replaceRoot(.settings)       // Swap the root route entirely

navigator.currentRoute                 // The topmost route
navigator.canGoBack                    // true when stack has more than one route
navigator.stack                        // The full route stack
```

### MIENavigationView

Two initializers are available:

```swift
// Creates and owns its own navigator internally
MIENavigationView(root: AppRoute.home) { route in ... }

// Uses an external navigator (useful for menu-driven apps that switch roots)
let navigator = MIENavigator(root: AppRoute.home)
MIENavigationView(navigator: navigator) { route in ... }
```

### View Modifiers

Apply these inside your page views to customize the navigation bar:

#### Title

```swift
// Plain string (renders with .headline font)
.mieNavigationTitle("My Page")

// Custom view for full control over styling
.mieNavigationTitle(Text("Styled").font(.title2).bold().foregroundStyle(.white))
```

#### Toolbar Buttons

```swift
.mieNavigationLeading {
    Button("Cancel") { /* ... */ }
}

.mieNavigationTrailing {
    Button { /* ... */ } label: {
        Image(systemName: "gear")
    }
}
```

When using `Image(systemName:)` in a toolbar slot, apply `.resizable().scaledToFit()` to make it scale correctly — SF Symbols render at their intrinsic font size by default and will not fill the slot automatically:

```swift
.mieNavigationTrailing {
    Button { /* ... */ } label: {
        Image(systemName: "square.and.arrow.up")
            .resizable()
            .scaledToFit()
    }
}
```

#### Navigation Bar Background

```swift
// Solid color
.mieNavigationBarBackground(Color.blue)

// Material blur
.mieNavigationBarBackground(.ultraThinMaterial)

// Any view
.mieNavigationBarBackground(
    LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
)
```

### Default Behaviors

| Condition | Behavior |
|-----------|----------|
| No title set | Title area is empty |
| Can go back (non-root page) | Automatic back button (chevron.left), always — overrides any custom leading item |
| At root + leading item set | Custom leading item shown |
| At root + no leading item | Empty leading area |
| No trailing item | Empty trailing area |
| No background set | System background color |

### Back Swipe Gesture

When navigated past the root, swiping right from anywhere on the content area pops back to the previous route. The threshold is 30% of the screen width.

## Multi-Root / Menu-Driven Apps

For apps with a side menu that switches between top-level sections, provide an external navigator and call `replaceRoot(_:)`:

```swift
struct AppShell: View {
    @State var navigator = MIENavigator(root: AppRoute.home)

    var body: some View {
        HStack(spacing: 0) {
            SideMenu { selection in
                navigator.replaceRoot(selection)
            }

            MIENavigationView(navigator: navigator) { route in
                switch route {
                case .home:    HomeView()
                case .detail:  DetailView()
                case .settings: SettingsView()
                }
            }
        }
    }
}
```

## Project Structure

```
Sources/MIENavigationView/
├── MIENavigationView.swift          # Main container with horizontal transitions
├── MIENavigator.swift               # Observable navigation state manager
├── MIENavigationBar.swift           # The header bar (title, leading, trailing, background)
├── MIENavigationPreferences.swift   # SwiftUI PreferenceKeys for bar customization
└── MIENavigationModifiers.swift     # Public .mieNavigation* view modifiers
```

## License

MIT
