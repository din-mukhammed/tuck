# Tuck

A free, open-source macOS menu bar app that tucks menu bar items out of sight.

Tuck is an independent project. It is not affiliated with any commercial menu bar manager.

## Use

Tuck adds a chevron to your menu bar and two faint ⋮ dividers to its left.

- Hold ⌘ and drag menu bar items left of the first ⋮ to hide them.
- Drag items left of the second ⋮ to keep them hidden even when Tuck is open.
- **Click** the chevron to show or hide the hidden items.
- **⌥-click** to also show the always-hidden items.
- **Right-click** for Settings and Quit.

Settings: hide again automatically after N seconds (on by default, 10 s), turn the always-hidden section on or off, open at login.

No Accessibility or Screen Recording permission is needed. Tuck widens its dividers so the items to their left move off screen.

Requires macOS 13 or later.

## Build

Needs only the Xcode Command Line Tools (Swift 6.1); no Xcode, no Swift Package Manager.

```bash
scripts/test.sh             # unit tests
scripts/build-app.sh --run  # builds dist/Tuck.app, installs it to ~/Applications and opens it
```

Some Command Line Tools installs keep a stale `usr/include/swift/module.modulemap` that breaks every Foundation import. `scripts/env.sh` detects it and hides it from the compiler with a VFS overlay; nothing on the system changes.

`scripts/status-items.swift` prints the position of every menu bar item window, which is how hiding is checked without Screen Recording permission:

```bash
source scripts/env.sh && swiftc "${SWIFTC_FLAGS[@]}" scripts/status-items.swift -o .build/status-items && .build/status-items
```

## Licence

MIT
