////
////  Component.swift
////  GUI
////
////  Created by Hồ Duy Quốc Bảo on 1/9/24.
////
//
//import SwiftUI
//
//// Component struct để đại diện cho từng thành phần UI
//struct Component: Identifiable {
//    let id = UUID()
//    let type: String
//    let content: String?
//    let label: String?
//    let children: [Component]?
//    let font: Font?
//    let foregroundColor: Color?
//    let isHidden: Bool?
//    let action: (() -> Void)?
//
//    init(type: String, content: String? = nil, label: String? = nil, children: [Component]? = nil, font: Font? = nil, foregroundColor: Color? = nil, isHidden: Bool? = false, action: (() -> Void)? = nil) {
//        self.type = type
//        self.content = content
//        self.label = label
//        self.children = children
//        self.font = font
//        self.foregroundColor = foregroundColor
//        self.isHidden = isHidden
//        self.action = action
//    }
//}
//
//// Screen class để đại diện cho mỗi màn hình trong ứng dụng
//class Screen: Identifiable {
//    let id = UUID()
//    let name: String
//    let components: [Component]
//
//    init(name: String, components: [Component]) {
//        self.name = name
//        self.components = components
//    }
//}
//
//// CacheManager class để quản lý caching cho các màn hình
//class CacheManager {
//    private var screenCache = NSCache<NSString, Screen>()
//    
//    static let shared = CacheManager()
//    
//    private init() {
//        screenCache.countLimit = 10 // Giới hạn số lượng màn hình lưu trong cache
//    }
//
//    func getScreen(forKey key: String) -> Screen? {
//        if let screen = screenCache.object(forKey: key as NSString) {
//            print("Cache hit for key: \(key)")
//            return screen
//        } else {
//            print("Cache miss for key: \(key)")
//            return nil
//        }
//    }
//
//    func setScreen(_ screen: Screen, forKey key: String) {
//        screenCache.setObject(screen, forKey: key as NSString)
//        print("Screen cached for key: \(key)")
//    }
//}
//
//// Hàm parse JSON cho Screen
//func parseScreenJSON(_ json: Any) -> Screen? {
//    guard let jsonObject = json as? [String: Any],
//          let name = jsonObject["name"] as? String,
//          let componentsJSON = jsonObject["components"] as? [[String: Any]] else {
//        print("Error: Invalid Screen JSON format.")
//        return nil
//    }
//
//    let components = componentsJSON.compactMap { parseComponentJSON($0) }
//    return Screen(name: name, components: components)
//}
//
//// Hàm parse JSON cho Component
//func parseComponentJSON(_ json: Any) -> Component? {
//    guard let jsonObject = json as? [String: Any],
//          let type = jsonObject["type"] as? String else {
//        print("Error: Invalid Component JSON format or missing 'type' field.")
//        return nil
//    }
//
//    let content = jsonObject["content"] as? String
//    let label = jsonObject["label"] as? String
//    var children: [Component]? = nil
//    let fontName = jsonObject["font"] as? String
//    let fontSize = jsonObject["fontSize"] as? CGFloat ?? 16
//    let font: Font? = fontName != nil ? Font.custom(fontName!, size: fontSize) : nil
//
//    // Chuyển đổi chuỗi thành đối tượng Color
//    let colorName = jsonObject["foregroundColor"] as? String
//    let foregroundColor: Color? = {
//        switch colorName?.lowercased() {
//        case "blue":
//            return .blue
//        case "red":
//            return .red
//        case "green":
//            return .green
//        case "yellow":
//            return .yellow
//        case "black":
//            return .black
//        case "white":
//            return .white
//        case "gray":
//            return .gray
//        default:
//            return nil
//        }
//    }()
//
//    // Hỗ trợ thuộc tính động `isHidden`
//    let isHidden = jsonObject["isHidden"] as? Bool ?? false
//
//    if let childArray = jsonObject["children"] as? [Any] {
//        children = childArray.compactMap { parseComponentJSON($0) }
//    }
//
//    return Component(
//        type: type,
//        content: content,
//        label: label,
//        children: children,
//        font: font,
//        foregroundColor: foregroundColor,
//        isHidden: isHidden
//    )
//}
//
//// Hàm xây dựng View từ Component
//func buildView(from component: Component, actionHandler: @escaping (String) -> Void) -> some View {
//    if component.isHidden == true {
//        return AnyView(EmptyView()) // Ẩn thành phần nếu thuộc tính isHidden là true
//    }
//
//    switch component.type {
//    case "VStack":
//        return AnyView(VStack {
//            if let children = component.children {
//                ForEach(children) { child in
//                    buildView(from: child, actionHandler: actionHandler)
//                }
//            }
//        })
//    case "HStack":
//        return AnyView(HStack {
//            if let children = component.children {
//                ForEach(children) { child in
//                    buildView(from: child, actionHandler: actionHandler)
//                }
//            }
//        })
//    case "Text":
//        var text = Text(component.content ?? "")
//        if let font = component.font {
//            text = text.font(font)
//        }
//        if let color = component.foregroundColor {
//            text = text.foregroundColor(color)
//        }
//        return AnyView(text)
//    case "Button":
//        return AnyView(Button(action: {
//            actionHandler(component.label ?? "")
//        }) {
//            Text(component.label ?? "")
//        })
//    case "Image":
//        if let imageName = component.content {
//            return AnyView(Image(systemName: imageName))
//        }
//        return AnyView(EmptyView())
//    case "Spacer":
//        return AnyView(Spacer())
//    case "Divider":
//        return AnyView(Divider())
//    default:
//        return AnyView(EmptyView())
//    }
//}
//
//// Hàm xây dựng màn hình từ Screen
//func buildScreenView(from screen: Screen, actionHandler: @escaping (String) -> Void) -> some View {
//    NavigationView {
//        VStack {
//            ForEach(screen.components) { component in
//                buildView(from: component, actionHandler: actionHandler)
//            }
//        }
//        .navigationTitle(screen.name)
//    }
//}
