import SwiftUI
import MarkdownUI
import GoogleGenerativeAI


extension View {
    func floatingPanel<Content: View>(
        isPresented: Binding<Bool>, contentRect: CGRect, @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(FloatingPanelModifier(isPresented: isPresented, contentRect: contentRect, view: content))
    }
}
struct ContentView: View {
    @EnvironmentObject var state: GeminiStates
    @State private var text: String = ""
    @State private var resText: String = ""
    let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default).startChat()
    
    var body: some View {
        ScrollView {
            VStack {
                Markdown(resText).padding(6)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(state.$isOpenGeminiUpdated) { _ in
            print("openGemini updated: \(state.openGemini)")
        }
        .floatingPanel(isPresented: $state.openGemini, contentRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 550, height: 30))) {
            FloatingView(model: model, text: $text, resText: $resText)
        }
        .padding(10)
    }
}
