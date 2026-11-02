import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let preferences = Preferences()
    private var menuBar: MenuBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBar = MenuBarController(preferences: preferences) { [weak self] in
            self?.showSettings()
        }
    }

    private func showSettings() {}
}
