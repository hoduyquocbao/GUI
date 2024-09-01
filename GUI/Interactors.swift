import SwiftUI

class Interactors {
    var screens: [[String: Any]]

    init(screens: [[String: Any]]) {
        self.screens = screens
    }

    func loadScreens() -> [Platform] {
        return screens.compactMap { objects in
            if let name = objects["name"] as? String, let url = objects["url"] as? String {
                return Platform(name: name, url: url)
            }
            return nil
        }
    }

    func loadScreen(named name: String) -> Screen? {
        if let screen = screens.first(where: { $0["name"] as? String == name }) {
            return parseScreen(screen)
        }
        return nil
    }

    private func parseScreen(_ object: Any) -> Screen? {
        guard let Object = object as? [String: Any],
              let name = Object["name"] as? String,
              let components = Object["components"] as? [[String: Any]] else {
            print("Error: Invalid Screen OBJECT format.")
            return nil
        }

        let url = Object["url"] as? String
        let state = Object["state"] as? [String: Any]
        let backgroundColorName = Object["backgroundColor"] as? String
        let backgroundColor: Color? = {
            switch backgroundColorName?.lowercased() {
            case "blue":
                return .blue
            case "red":
                return .red
            case "green":
                return .green
            case "yellow":
                return .yellow
            case "black":
                return .black
            case "white":
                return .white
            case "gray":
                return .gray
            default:
                return nil
            }
        }()
        let isTransparent = Object["isTransparent"] as? Bool ?? false
        let blurEffectName = Object["blurEffect"] as? String
        let blurEffect: NSVisualEffectView.Material? = {
            switch blurEffectName?.lowercased() {
            case "light":
                return .windowBackground
            case "dark":
                return .underPageBackground
            case "extralight":
                return .menu
            case "chrome":
                return .contentBackground
            default:
                return nil
            }
        }()
        let backgroundImage = Object["backgroundImage"] as? String

        let component = components.compactMap { parseComponent($0) }
        return Screen(name: name, url: url, state: state, components: component, backgroundColor: backgroundColor, isTransparent: isTransparent, blurEffect: blurEffect, backgroundImage: backgroundImage)
    }

    private func parseComponent(_ objects: Any) -> Component? {
        guard let Object = objects as? [String: Any],
              let type = Object["type"] as? String else {
            print("Error: Invalid Component OBJECT format or missing 'type' field.")
            return nil
        }

        let content = Object["content"] as? String
        let label = Object["label"] as? String
        var children: [Component]? = nil
        let fontName = Object["font"] as? String
        let fontSize = Object["fontSize"] as? CGFloat ?? 16
        let font: Font? = fontName != nil ? Font.custom(fontName!, size: fontSize) : nil

        let colorName = Object["foregroundColor"] as? String
        let foregroundColor: Color? = {
            switch colorName?.lowercased() {
            case "blue":
                return .blue
            case "red":
                return .red
            case "green":
                return .green
            case "yellow":
                return .yellow
            case "black":
                return .black
            case "white":
                return .white
            case "gray":
                return .gray
            default:
                return nil
            }
        }()

        let isHidden = Object["isHidden"] as? Bool ?? false
        let action = Object["action"] as? String

        if let childArray = Object["children"] as? [Any] {
            children = childArray.compactMap { parseComponent($0) }
        }

        return Component(
            type: type,
            content: content,
            label: label,
            children: children,
            font: font,
            foregroundColor: foregroundColor,
            isHidden: isHidden,
            action: action
        )
    }
}
