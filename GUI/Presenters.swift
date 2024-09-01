//
//  Interactors.swift
//  GUI
//
//  Created by Hồ Duy Quốc Bảo on 2/9/24.
//

import Foundation
import Combine

class Presenters: ObservableObject {
    var interactor: Interactors
    private var router: Routers
    @Published var currentScreen: Screen?

    init(interactor: Interactors, router: Routers) {
        self.interactor = interactor
        self.router = router
    }

    func loadScreen(named name: String) {
        if let screen = interactor.loadScreen(named: name) {
            currentScreen = screen
        }
    }

    func handleAction(_ action: String) {
        router.navigate(action, presenter: self)
    }
}
