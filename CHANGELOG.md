# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- `MIENavigationView` now keys rendered pages by stack position, allowing duplicate routes/IDs in the stack without identity collisions
- `MIENavigator` now protects stack invariants with `public private(set)` stack access and a non-empty `replaceStack(_:)` API
- `MIENavigationView` now uses explicit owned/external navigator storage, removing unused ownership state

### Fixed
- Navigation bar preferences now clear correctly when a top page omits a title/leading/trailing/background/back-button color modifier

## [1.1.0] - 2026-02-17

### Added
- `.mieNavigationBackButtonColor(_:)` modifier to set the back button foreground color per page; defaults to accent color when unset

### Changed
- Back button now uses a fixed 25×25 square frame with `.resizable().scaledToFit()` instead of font-based sizing
- Leading and trailing toolbar slots enforce a 25×25 minimum square frame for consistent layout and tap targets

### Fixed
- Navigation bar title is now always centered relative to the full bar width, regardless of leading or trailing button widths

## [1.0.1] - 2026-02-17

### Changed
- Back button now always takes priority in the leading slot when navigating past the root, overriding any custom leading item set via `.mieNavigationLeading`

## [1.0.0] - 2026-02-17

### Added
- `MIENavigator<Route>` observable navigation state manager with `push`, `pop`, `popToRoot`, and `replaceRoot` methods
- `MIENavigationView` container with horizontal sliding page transitions animated by stack depth
- Automatic back button (chevron.left) in the leading slot when navigated past the root
- Edge-swipe gesture to pop, triggered at 30% of screen width
- `.mieNavigationTitle()` modifier accepting a plain `String` or any custom `View`
- `.mieNavigationLeading {}` and `.mieNavigationTrailing {}` toolbar button modifiers
- `.mieNavigationBarBackground()` modifier accepting any `View` or `Material`
- Support for an externally-provided navigator via `MIENavigationView(navigator:)` for menu-driven multi-root apps
- iOS 17+ and macOS 14+ support
