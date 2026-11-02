import AppKit
import SwiftUI

final class SettingsWindow {
    private let window: NSWindow

    init(preferences: Preferences) {
        let controller = NSHostingController(rootView: SettingsView(preferences: preferences))
        window = NSWindow(contentViewController: controller)
        window.title = "Tuck Settings"
        window.styleMask = [.titled, .closable]
        window.isReleasedWhenClosed = false
    }

    func show() {
        if !window.isVisible {
            window.center()
        }
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }
}
