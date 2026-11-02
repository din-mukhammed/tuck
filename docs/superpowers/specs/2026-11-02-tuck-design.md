# Tuck — design (v1)

Tuck is a free, open-source macOS menu bar manager: it hides menu bar items behind a toggle. It is inspired by commercial menu bar managers but shares no name, icon, copy or code with them.

## Goal and success criteria

- A native menu bar app (`LSUIElement`, no Dock icon) that hides and shows the user's menu bar items.
- Builds with the Command Line Tools alone (Swift 6.1, no Xcode).
- Done = the app builds, runs on the author's Mac (macOS 15.7), and items placed left of the divider disappear on toggle and come back on the next toggle, verified with before/after screenshots of the menu bar.

## Scope

In v1:
- A Tuck icon that toggles the **hidden** section.
- An **always-hidden** section further left, shown only on ⌥-click (can be switched off in Settings).
- **Auto-hide** after N seconds (default 10, range 2–60, can be turned off); the timer is paused while the pointer is in the menu bar.
- Right-click menu on the icon: Settings…, Quit Tuck.
- A Settings window: auto-hide on/off + delay, always-hidden section on/off, launch at login, one line of help on arranging items.
- Launch at login through `SMAppService.mainApp`.

Out of v1: a secondary bar, an item list with icons, rules, search, hover reveal, spacing, a Homebrew cask, an app icon beyond an SF Symbol.

## Technique

The status-item length trick (the technique Hidden Bar and Ice also use; written from scratch here, no code copied). Tuck owns three `NSStatusItem`s, right to left:

```
visible items │ Tuck icon │ ⋮ hidden-divider  hidden items │ ⋮ always-divider  always-hidden items
```

- A divider's length is either **collapsed** (a thin `⋮` mark, ~8 pt, visible while that section is shown) or **expanded** (10,000 pt). An expanded divider pushes every item to its left off screen.
- Items are moved between sections by ⌘-dragging, a macOS feature. Each status item has an `autosaveName`, so macOS keeps their positions across launches.
- No Accessibility or Screen Recording permission is needed.

## States

`VisibilityState` is a pure value type:

| State | hidden-divider | always-divider |
|---|---|---|
| `hidden` (default) | expanded | expanded |
| `shown` | collapsed | expanded |
| `allShown` | collapsed | collapsed |

Transitions:
- click: `hidden → shown`, `shown|allShown → hidden`
- ⌥-click: `hidden|shown → allShown` (or `shown` when the always-hidden section is off), `allShown → hidden`
- auto-hide timer fires: `* → hidden`
- the always-hidden section is turned off: the always-divider is removed from the menu bar; `allShown` is never entered.

The auto-hide timer starts on every entry into `shown` / `allShown`, is cancelled on `hidden`, and is re-armed (not fired) when the delay elapses while the pointer is inside the menu bar's rectangle.

## Units

- `TuckApp` (`main.swift`, `AppDelegate`): sets `.accessory` activation policy, builds the controller.
- `MenuBarController`: owns the three status items, applies widths from the state, handles clicks (left, ⌥, right), owns the auto-hide timer.
- `VisibilityState`: the state enum and its transition functions; pure, unit-tested.
- `Preferences`: `UserDefaults`-backed settings (`autoHideEnabled`, `autoHideDelay`, `alwaysHiddenEnabled`), publishes changes.
- `SettingsWindow` + `SettingsView` (SwiftUI in an `NSWindow`, brought to front with `NSApp.activate`).
- `LoginItem`: wraps `SMAppService.mainApp` register/unregister/status.

## Build and distribution

- Swift Package, `macOS(.v13)`, an executable target `Tuck`, a library target `TuckCore` (state + preferences logic) and a test target using Swift Testing.
- `scripts/build-app.sh`: `swift build -c release`, assembles `Tuck.app` (Info.plist with `LSUIElement`, bundle id `dev.tuck.Tuck`), ad-hoc `codesign`, copies it to `~/Applications`.
- MIT licence, README with build steps. A GitHub repo and a Homebrew cask are later.

## Errors and edge cases

- Launch at login failing to register (e.g. a bundle outside an Applications folder) shows the error under the toggle in Settings and leaves the toggle off.
- First launch: the dividers sit right next to the Tuck icon, so nothing is hidden until the user ⌘-drags items left of the divider; the help line in Settings says so.

## Testing

- `swift test`: every `VisibilityState` transition and the auto-hide decision (fire vs re-arm).
- Manual on the author's Mac: build, launch, ⌘-drag an item left of the divider, then before/after `screencapture` of the menu bar for click, ⌥-click and auto-hide.
