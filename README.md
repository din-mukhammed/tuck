# Tuck

A free, open-source macOS menu bar app that tucks menu bar items out of sight.

Tuck is an independent project. It is not affiliated with any commercial menu bar manager.

## Install

With Homebrew:

```bash
brew install --cask din-mukhammed/tuck/tuck
```

Or download `Tuck-<version>.zip` from [Releases](https://github.com/din-mukhammed/tuck/releases), unzip it and move `Tuck.app` to Applications.

Tuck is not notarized by Apple yet, so the first launch shows "Apple could not verify Tuck…". Click **Done**, open **System Settings → Privacy & Security**, and click **Open Anyway** next to the Tuck message. Or, in Terminal:

```bash
xattr -dr com.apple.quarantine /Applications/Tuck.app
```

Universal (Apple silicon and Intel), macOS 13 or later.

## Use

Tuck adds a chevron to your menu bar and two faint ⋮ dividers to its left.

- Hold ⌘ and drag menu bar items left of the first ⋮ to hide them.
- Drag items left of the second ⋮ to keep them hidden even when Tuck is open.
- **Click** the chevron to show or hide the hidden items.
- **⌥-click** to also show the always-hidden items.
- **Right-click** for Settings and Quit.

Settings: hide again automatically after N seconds (on by default, 10 s), turn the always-hidden section on or off, open at login.

No Accessibility or Screen Recording permission is needed. Tuck widens its dividers so the items to their left move off screen.

## Build

Needs only the Xcode Command Line Tools (Swift 6.1); no Xcode, no Swift Package Manager.

```bash
scripts/test.sh             # unit tests
scripts/build-app.sh        # builds a universal dist/Tuck.app
scripts/build-app.sh --run  # also installs it to ~/Applications and opens it
```

### Release

`scripts/release.sh` tests, builds, zips `dist/Tuck-<version>.zip`, publishes a GitHub release tagged `v<version>` (the version comes from `Resources/Info.plist`) and updates the cask in [din-mukhammed/homebrew-tuck](https://github.com/din-mukhammed/homebrew-tuck). Bump `CFBundleShortVersionString` and commit before running it.

With an Apple Developer ID it signs and notarizes too. Store notary credentials once, then pass both variables:

```bash
xcrun notarytool store-credentials tuck-notary --apple-id you@example.com --team-id TEAMID
TUCK_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" TUCK_NOTARY_PROFILE=tuck-notary scripts/release.sh
```

Some Command Line Tools installs keep a stale `usr/include/swift/module.modulemap` that breaks every Foundation import. `scripts/env.sh` detects it and hides it from the compiler with a VFS overlay; nothing on the system changes.

`scripts/status-items.swift` prints the position of every menu bar item window, which is how hiding is checked without Screen Recording permission:

```bash
source scripts/env.sh && swiftc "${SWIFTC_FLAGS[@]}" scripts/status-items.swift -o .build/status-items && .build/status-items
```

## Licence

MIT
