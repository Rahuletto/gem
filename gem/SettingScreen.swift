import SwiftUI
import KeyboardShortcuts

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Toggle Gemini:", name: .toggleGemini)
        }
    }
}
