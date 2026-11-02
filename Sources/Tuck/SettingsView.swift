import SwiftUI

struct SettingsView: View {
    @ObservedObject var preferences: Preferences
    @State private var openAtLogin = LoginItem.isEnabled
    @State private var loginError: String?

    var body: some View {
        Form {
            Section {
                Toggle("Hide items again automatically", isOn: $preferences.autoHideEnabled)
                Stepper(value: $preferences.autoHideDelay, in: Preferences.delayRange, step: 1) {
                    Text("After \(Int(preferences.autoHideDelay)) seconds")
                }
                .disabled(!preferences.autoHideEnabled)
                Toggle("Always-hidden section (⌥-click to show)", isOn: $preferences.alwaysHiddenEnabled)
            }
            Section {
                Toggle("Open at login", isOn: $openAtLogin)
                    .onChange(of: openAtLogin) { on in
                        setOpenAtLogin(on)
                    }
                if let loginError {
                    Text(loginError)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
            Section {
                Text("Hold ⌘ and drag menu bar items left of the ⋮ divider to hide them. Items left of the second ⋮ stay hidden until you ⌥-click Tuck.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .formStyle(.grouped)
        .frame(width: 420, height: 360)
    }

    private func setOpenAtLogin(_ on: Bool) {
        guard on != LoginItem.isEnabled else {
            loginError = nil
            return
        }
        do {
            try LoginItem.setEnabled(on)
            loginError = nil
        } catch {
            loginError = error.localizedDescription
            openAtLogin = LoginItem.isEnabled
        }
    }
}
