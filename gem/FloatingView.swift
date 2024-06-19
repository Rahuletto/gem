import SwiftUI
import AppKit
import GoogleGenerativeAI

struct FloatingView: View {
    let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default).startChat()
    @Binding var text: String
    @Binding var resText: String


    var body: some View {
        ZStack {
            BlurBackground(material: .sidebar, blendingMode: .withinWindow)
            HStack {
                Image(systemName: "questionmark.diamond.fill").padding(5).font(.system(size: 4))
                    .opacity(0)
                VStack {
                    InputField(
                        text: $text,
                        placeholder: "Ask Gemini.",
                        fontSize: 18,
                        performAsyncOperation: {
                            Task {
                                    do {
                                        resText = ""
                                        let response = try await model.sendMessage(text)
                                        if let res = response.text {
                                            DispatchQueue.main.async {
                                                resText = res
                                                print(res)
                                            }
                                        }
                                    } catch {
                                        print("Error occurred: \(error)")
                                        DispatchQueue.main.async {
                                            resText = "An error occurred."
                                        }
                                    }
                                }
                        },
                        onKeyPress: {
                            
                        }
                    )
                    .background(Color.clear)
                }
            }
        }.background(Color.white.opacity(0.02))
    }

}
