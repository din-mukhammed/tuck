<div align="center">

# Tuck

**Tuck menu bar items out of sight. Free and open source.**

[![Latest release](https://img.shields.io/github/v/release/din-mukhammed/tuck?label=release)](https://github.com/din-mukhammed/tuck/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/din-mukhammed/tuck/total)](https://github.com/din-mukhammed/tuck/releases)
[![macOS 13+](https://img.shields.io/badge/macOS-13%2B-blue)](#requirements)
[![Licence: MIT](https://img.shields.io/github/license/din-mukhammed/tuck)](LICENSE)

[Install](#install) · [Usage](#usage) · [FAQ](#faq) · [Build from source](#build-from-source)

</div>

---

Tuck is a tiny native menu bar manager for macOS. It hides the icons you rarely need behind a single chevron, so your menu bar stays clean and fewer icons disappear behind the notch.

Tuck is an independent project and is not affiliated with any commercial menu bar manager.

## Features

- **One click to hide or show** everything you've tucked away.
- **Always-hidden section** for icons you almost never need, revealed with ⌥-click.
- **Auto-hide**: items tuck themselves away again after a delay you choose. The timer waits while your pointer is in the menu bar.
- **Launch at login.**
- **No permissions**: no Accessibility, no Screen Recording.
- **Native and small**: Swift and AppKit, about 70 KB zipped, universal for Apple silicon and Intel.

## Install

### Homebrew

```bash
brew tap din-mukhammed/tuck https://github.com/din-mukhammed/tuck
brew install --cask tuck
```

### Manual

Download `Tuck-<version>.zip` from the [latest release](https://github.com/din-mukhammed/tuck/releases/latest), unzip it and move `Tuck.app` to Applications.

### First launch

Tuck is not notarized by Apple yet, so macOS says it "could not verify Tuck". Click **Done**, open **System Settings → Privacy & Security** and click **Open Anyway** next to the Tuck message. Or run:

```bash
xattr -dr com.apple.quarantine /Applications/Tuck.app
```

### Requirements

macOS 13 Ventura or later, Apple silicon or Intel.

## Usage

Tuck adds a chevron and two faint `|` dividers to your menu bar. Arrange your icons by holding **⌘** and dragging them:

```
 always hidden  |  hidden  |  ‹  always visible
```

| Action | Result |
| --- | --- |
| Click the chevron | Show or hide the hidden section |
| ⌥-click the chevron | Also show the always-hidden section |
| Right-click the chevron | Settings… and Quit |

The dividers are only visible while items are shown. Icons placed between the first `|` and the chevron stay visible all the time.

### Settings

| Setting | Default |
| --- | --- |
| Hide items again automatically | On, after 10 s (2–60 s) |
| Always-hidden section | On |
| Open at login | Off |

## FAQ

**How does Tuck hide icons without any permissions?**
Each divider is itself a menu bar item. To hide, Tuck stretches a divider very wide, which pushes every icon to its left off the edge of the screen. To show, it shrinks the divider back to a thin line.

**Where did my icon go?**
Click the chevron (or ⌥-click it) and drag the icon back to the right of the first `|`.

**Does it work with the notch and multiple displays?**
Yes. macOS mirrors the menu bar on every display, and Tuck's dividers hide items on each of them.

**How do I uninstall it?**
Quit Tuck from its right-click menu, then delete `Tuck.app`. With Homebrew: `brew uninstall --zap --cask tuck`.

## Build from source

Only the Xcode Command Line Tools are needed (Swift 6.1). No Xcode and no Swift Package Manager.

```bash
git clone https://github.com/din-mukhammed/tuck.git && cd tuck
scripts/test.sh             # unit tests
scripts/build-app.sh        # builds a universal dist/Tuck.app
scripts/build-app.sh --run  # also installs it to ~/Applications and opens it
```

<details>
<summary>Notes for maintainers</summary>

**Releasing.** Bump `CFBundleShortVersionString` in `Resources/Info.plist`, commit, then run `scripts/release.sh`. It tests, builds, zips `dist/Tuck-<version>.zip`, publishes the GitHub release `v<version>` and updates the version and checksum in `Casks/tuck.rb`.

**Notarizing.** With an Apple Developer ID, store notary credentials once and pass both variables:

```bash
xcrun notarytool store-credentials tuck-notary --apple-id you@example.com --team-id TEAMID
TUCK_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)" TUCK_NOTARY_PROFILE=tuck-notary scripts/release.sh
```

**Broken Command Line Tools.** Some installs keep a stale `usr/include/swift/module.modulemap` that breaks every Foundation import. `scripts/env.sh` detects it and hides it from the compiler with a VFS overlay; nothing on the system changes.

**Checking what is hidden.** `scripts/status-items.swift` prints the position of every menu bar item, which shows what is off screen without Screen Recording permission:

```bash
source scripts/env.sh && swiftc "${SWIFTC_FLAGS[@]}" scripts/status-items.swift -o .build/status-items && .build/status-items
```

</details>

## Contributing

Issues and pull requests are welcome. Please run `scripts/test.sh` before sending a change.

## Licence

[MIT](LICENSE) © 2026 Din
