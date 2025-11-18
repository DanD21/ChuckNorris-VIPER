//
//  CategoriesRouter.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import SwiftUI

// MARK: - Router Protocol
protocol CategoriesRouterProtocol: Sendable {
    func showJokeDetail(for category: String, joke: Joke)
}

// MARK: - Router Implementation
@MainActor
class CategoriesRouter: CategoriesRouterProtocol {
    weak var navigationState: CategoriesNavigationState?

    func showJokeDetail(for category: String, joke: Joke) {
        navigationState?.selectedJoke = JokeDetail(category: category, joke: joke)
    }
}

// MARK: - Navigation State
struct JokeDetail: Identifiable {
    let id = UUID()
    let category: String
    let joke: Joke
}

@MainActor
class CategoriesNavigationState: ObservableObject {
    @Published var selectedJoke: JokeDetail?
}
