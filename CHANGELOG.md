# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
