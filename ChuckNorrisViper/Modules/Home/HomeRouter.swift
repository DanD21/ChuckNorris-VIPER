//
//  HomeRouter.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import SwiftUI

// MARK: - Router Protocol
protocol HomeRouterProtocol: Sendable {
    func navigateToCategories()
}

// MARK: - Router Implementation
@MainActor
class HomeRouter: HomeRouterProtocol {
    weak var navigationState: NavigationState?

    func navigateToCategories() {
        navigationState?.showCategories = true
    }
}

// MARK: - Navigation State
@MainActor
class NavigationState: ObservableObject {
    @Published var showCategories = false
}
