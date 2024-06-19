import SwiftUI
import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleGemini = Self("toggleGemini")
}

@main
struct gemApp: App {
    @StateObject var state = GeminiStates()
    let appDelegate = AppDelegate()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                Button("Toggle Gemini") {
                    state.updateState(true)
                }
                .keyboardShortcut(" ", modifiers: [.option])
            }
        }
        Settings {
            SettingsScreen()
        }
    }

    init() {
        setupKeyboardShortcut()
    }

    func setupKeyboardShortcut() {
        KeyboardShortcuts.onKeyDown(for: .toggleGemini) { [self] in
            state.updateState(true)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupBackgroundRunning()
    }

    func setupBackgroundRunning() {
        NSApp.setActivationPolicy(.accessory)
    }
}


class GeminiStates: ObservableObject {
    @Published var openGemini: Bool = false
    @Published var isOpenGeminiUpdated: Bool = false

    func updateState(_ val: Bool) {
        openGemini = val
        isOpenGeminiUpdated = true
    }
}
