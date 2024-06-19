import SwiftUI

struct BlurBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
 
    func makeNSView(context: Context) -> NSVisualEffectView {
        context.coordinator.visualEffectView
    }
 
    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        context.coordinator.update(
            material: material,
            blendingMode: blendingMode
        )
    }
 
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
 
    class Coordinator {
        let visualEffectView = NSVisualEffectView()
 
        init() {
            visualEffectView.blendingMode = .behindWindow
            visualEffectView.material = .sidebar
            visualEffectView.isEmphasized = false
            visualEffectView.alphaValue = 5
        }
 
        func update(material: NSVisualEffectView.Material,
                    blendingMode: NSVisualEffectView.BlendingMode) {
            visualEffectView.material = material
        }
    }
}
