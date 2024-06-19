import SwiftUI
import AppKit

public extension NSColor {

    class func hexColor(_ rgbValue: Int, alpha: CGFloat = 1.0) -> NSColor {

    return NSColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue:((CGFloat)(rgbValue & 0xFF))/255.0, alpha:alpha)

  }

}

struct InputField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var fontSize: CGFloat

    var performAsyncOperation: () async -> Void // Async operation function
    var onKeyPress: () -> Void

    
    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding var text: String
        var performAsyncOperation: () async -> Void
        var onKeyPress: () -> Void
        
        init(text: Binding<String>, performAsyncOperation: @escaping () async -> Void, onKeyPress: @escaping () -> Void) {
            _text = text
            self.performAsyncOperation = performAsyncOperation
            self.onKeyPress = onKeyPress
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                if NSEvent.modifierFlags.contains(.shift) {
                    Task {
                        text = text + "\n"
                    }
                } else {
                    Task {
                        await performAsyncOperation()
                        if let textField = control as? NSTextField {
                            
                            let gradientLayer = CAGradientLayer()
                            let bounds = textField.bounds
                            
                            gradientLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
                            gradientLayer.colors = [
                                NSColor.hexColor(0xF9DCBA).cgColor,
                                NSColor.hexColor(0xFAEEE2).cgColor,
                                NSColor.hexColor(0xCDD7EE).cgColor,
                                NSColor.hexColor(0x73C7F4).cgColor,
                                NSColor.hexColor(0x73C7F4).cgColor,
                                NSColor.hexColor(0xCDD7EE).cgColor,
                                NSColor.hexColor(0xFAEEE2).cgColor,
                                NSColor.hexColor(0xF9DCBA).cgColor
                            ]
                            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
                            
                            let animation = CABasicAnimation(keyPath: "transform.translation.x")
                            animation.fromValue = -bounds.width
                            animation.toValue = bounds.width
                            animation.duration = 2.0
                            animation.repeatCount = .infinity
                            
                            gradientLayer.add(animation, forKey: "gradientAnimation")
                            
                            let textLayer = CATextLayer()
                            textLayer.frame = bounds
                            textLayer.string = textField.stringValue
                            textLayer.font = textField.font
                            textLayer.alignmentMode = .left
                            textLayer.fontSize = 18
                            textLayer.foregroundColor = NSColor.black.cgColor
                            textLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 1.0
                            
                            
                            textField.layer?.mask = textLayer
                            textField.layer?.addSublayer(gradientLayer)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                textField.stringValue = ""
                                self.text = ""
                                gradientLayer.removeFromSuperlayer()
                                textField.layer?.mask = nil
                            }
                        }
                    }
                }
                return true
            }
            return false
        }
        
        func controlTextDidChange(_ obj: Notification) {
            onKeyPress()
            guard let textField = obj.object as? NSTextField else { return }
            text = textField.stringValue
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, performAsyncOperation: performAsyncOperation, onKeyPress: onKeyPress)
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.placeholderString = placeholder
        textField.backgroundColor = .clear
        textField.isBordered = false
        textField.drawsBackground = false
        textField.isEditable = true
        textField.isSelectable = true
        textField.focusRingType = .none
        textField.isBezeled = false
        textField.font = NSFont.systemFont(ofSize: fontSize)

        if let cell = textField.cell as? NSTextFieldCell {
            cell.backgroundColor = .clear
            cell.drawsBackground = false
        }

        textField.wantsLayer = true
        textField.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.2).cgColor

        // Add a blur effect
        let visualEffectView = NSVisualEffectView()
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .sidebar
        visualEffectView.state = .active
        visualEffectView.autoresizingMask = [.width, .height]
        textField.addSubview(visualEffectView, positioned: .below, relativeTo: nil)

        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
        let newSize = nsView.sizeThatFits(CGSize(width: nsView.bounds.width, height: .greatestFiniteMagnitude))
        nsView.frame.size.height = min(newSize.height, 250)
    }
}
