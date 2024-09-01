import SwiftUI

// Model cho Component
struct Component: Identifiable {
    let id = UUID()
    let type: String
    let content: String?
    let label: String?
    let children: [Component]?
    let font: Font?
    let foregroundColor: Color?
    let isHidden: Bool
    let action: String?

    init(type: String, content: String? = nil, label: String? = nil, children: [Component]? = nil, font: Font? = nil, foregroundColor: Color? = nil, isHidden: Bool = false, action: String? = nil) {
        self.type = type
        self.content = content
        self.label = label
        self.children = children
        self.font = font
        self.foregroundColor = foregroundColor
        self.isHidden = isHidden
        self.action = action
    }
}

// Model cho Screen
class Screen: Identifiable {
    let id = UUID()
    let name: String
    let url: String?
    let state: [String: Any]?
    let components: [Component]
    let backgroundColor: Color?
    let isTransparent: Bool
    let blurEffect: NSVisualEffectView.Material?
    let backgroundImage: String?

    init(name: String, url: String? = nil, state: [String: Any]? = nil, components: [Component], backgroundColor: Color? = nil, isTransparent: Bool = false, blurEffect: NSVisualEffectView.Material? = nil, backgroundImage: String? = nil) {
        self.name = name
        self.url = url
        self.state = state
        self.components = components
        self.backgroundColor = backgroundColor
        self.isTransparent = isTransparent
        self.blurEffect = blurEffect
        self.backgroundImage = backgroundImage
    }
}

// Định nghĩa kiểu dữ liệu cho màn hình
struct Platform: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let url: String
}
