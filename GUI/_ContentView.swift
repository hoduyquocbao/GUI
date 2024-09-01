////
////  ContentView.swift
////  GUI
////
////  Created by Hồ Duy Quốc Bảo on 1/9/24.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    let screensJSON: [[String: Any]] = [
//        [
//            "name": "Home",
//            "components": [
//                ["type": "Text", "content": "Welcome to the Home Screen!", "font": "Arial", "fontSize": 24, "foregroundColor": "blue"],
//                [
//                    "type": "HStack",
//                    "children": [
//                        ["type": "Button", "label": "Go to Settings"],
//                        ["type": "Text", "content": "Enjoy your stay!", "font": "Courier", "fontSize": 16, "foregroundColor": "red"]
//                    ]
//                ],
//                ["type": "Spacer"],
//                ["type": "Divider"],
//                ["type": "Image", "content": "star"]
//            ]
//        ],
//        [
//            "name": "Settings",
//            "components": [
//                ["type": "Text", "content": "Settings Screen", "font": "Arial", "fontSize": 24, "foregroundColor": "green"],
//                ["type": "Button", "label": "Back to Home"]
//            ]
//        ]
//    ]
//
//    @State private var currentScreen: Screen?
//
//    var body: some View {
//        if let screen = currentScreen {
//            buildScreenView(from: screen, actionHandler: handleAction)
//        } else {
//            Text("Loading...")
//                .onAppear {
//                    loadInitialScreen()
//                }
//        }
//    }
//
//    func loadInitialScreen() {
//        if let firstScreenJSON = screensJSON.first,
//           let firstScreen = loadScreen(forKey: "Home", from: firstScreenJSON) {
//            currentScreen = firstScreen
//        }
//    }
//
//    func handleAction(_ action: String) {
//        switch action {
//        case "Go to Settings":
//            goToSettings()
//        case "Back to Home":
//            goToHome()
//        default:
//            print("\(action) clicked!")
//        }
//    }
//
//    func goToSettings() {
//        if let settingsScreenJSON = screensJSON.first(where: { $0["name"] as? String == "Settings" }),
//           let settingsScreen = loadScreen(forKey: "Settings", from: settingsScreenJSON) {
//            currentScreen = settingsScreen
//        }
//    }
//
//    func goToHome() {
//        if let homeScreenJSON = screensJSON.first(where: { $0["name"] as? String == "Home" }),
//           let homeScreen = loadScreen(forKey: "Home", from: homeScreenJSON) {
//            currentScreen = homeScreen
//        }
//    }
//
//    func loadScreen(forKey key: String, from json: [String: Any]) -> Screen? {
//        if let cachedScreen = CacheManager.shared.getScreen(forKey: key) {
//            return cachedScreen
//        } else if let newScreen = parseScreenJSON(json) {
//            CacheManager.shared.setScreen(newScreen, forKey: key)
//            return newScreen
//        }
//        return nil
//    }
//}
//
//
//
//
//#Preview {
//    ContentView()
//}
