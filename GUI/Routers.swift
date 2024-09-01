
//
//  viper.swift
//  GUI
//
//  Created by Hồ Duy Quốc Bảo on 1/9/24.
//


import Foundation
import Combine

class Routers {
    private var routes: [String: (Presenters) -> Void] = [:]

    func registerScreens(from screens: [Screen], presenter: Presenters) {
        for screen in screens {
            if let action = screen.url {
                register(action) { presenter in
                    presenter.loadScreen(named: screen.name)
                }
            }
        }
    }

    func register(_ action: String, handler: @escaping (Presenters) -> Void) {
        routes[action] = handler
    }

    func navigate(_ action: String, presenter: Presenters) {
        if let route = routes[action] {
            route(presenter)
        } else {
            print("No route registered for action: \(action)")
        }
    }
}
