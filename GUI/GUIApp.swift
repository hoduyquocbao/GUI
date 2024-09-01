import SwiftUI
import Combine

@main
struct Application: App {
    var body: some Scene {
        WindowGroup {
            let router = Routers()
            let interactor = Interactors(screens: [
                [
                    "name": "Home",
                    "url": "goToHome",
                    "backgroundColor": "white",
                    "isTransparent": false,
                    "blurEffect": "chrome",
                    "backgroundImage": "exampleImage", // Đảm bảo hình ảnh này tồn tại trong Assets.xcassets
                    "components": [
                        ["type": "Text", "content": "Welcome to the Home Screen!", "font": "Arial", "fontSize": 24, "foregroundColor": "blue"],
                        [
                            "type": "HStack",
                            "children": [
                                ["type": "Button", "label": "Go to Settings", "action": "goToSettings"],
                                ["type": "Text", "content": "Enjoy your stay!", "font": "Courier", "fontSize": 16, "foregroundColor": "red"]
                            ]
                        ],
                        ["type": "Spacer"],
                        ["type": "Divider"],
                        ["type": "Image", "content": "star"]
                    ]
                ],
                [
                    "name": "Settings",
                    "url": "goToSettings",
                    "backgroundColor": "green",
                    "isTransparent": false,
                    "blurEffect": NSNull(),
                    "backgroundImage": NSNull(),
                    "components": [
                        ["type": "Text", "content": "Settings Screen", "font": "Arial", "fontSize": 24, "foregroundColor": "green"],
                        ["type": "Button", "label": "Back to Home", "action": "goToHome"]
                    ]
                ]
            ])
            
            let presenter = Presenters(interactor: interactor, router: router)

            // Tạo danh sách các màn hình từ Object schema
            let screens = interactor.screens.compactMap { interactor.loadScreen(named: $0["name"] as? String ?? "") }

            // Tự động đăng ký các màn hình với router
            router.registerScreens(from: screens, presenter: presenter)

            return Views(presenter: presenter)
        }
    }
}
