# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build

```bash
swift build
```

There are no test targets, linting tools, or CI pipelines configured.

## Package Overview

MIENavigationView is a SwiftUI navigation container that replaces `NavigationStack` with horizontal sliding page transitions. It targets iOS 17+ / macOS 14+, has no external dependencies, and uses Swift 5.9's `@Observable` macro.

## Architecture

The data flow follows this path:

1. **MIENavigator** (`@Observable`) holds the route stack and is injected into the SwiftUI environment. Child views access it via `@Environment(MIENavigator<Route>.self)`.
2. **Child views** set nav bar content (title, leading/trailing buttons, background) using **view modifiers** (`.mieNavigationTitle()`, etc.) which write to **SwiftUI PreferenceKeys**.
3. **MIENavigationView** observes those preferences via `.onPreferenceChange()` at the HStack level (above the ForEach) and passes the resolved values down to **MIENavigationBar** for rendering.

Preferences are collected at the HStack level (not per-page) so that when a page is popped, SwiftUI re-reduces across remaining pages and the bar updates correctly.

### EquatableViewBox

`AnyView` doesn't conform to `Equatable`, which `onPreferenceChange` requires. `EquatableViewBox` wraps an `AnyView` with a UUID-based identity to satisfy this constraint.

### Cross-platform

The nav bar default background uses `#if canImport(UIKit)` to choose between `UIColor.systemBackground` (iOS) and `NSColor.windowBackgroundColor` (macOS).

## Route Constraints

Routes must conform to both `Identifiable` and `Hashable`. The typical pattern is an enum with `var id: Self { self }`.

## Keeping Docs in Sync

- **README.md** — Update the API Reference section whenever a public API changes: method signatures on `MIENavigator`, initializers on `MIENavigationView`, or any `.mieNavigation*` view modifier.
- **CHANGELOG.md** — Add an entry under `[Unreleased]` whenever a new feature is implemented. Use the appropriate category (`Added`, `Changed`, `Fixed`, `Removed`, `Deprecated`, `Security`) per the Keep a Changelog format.
