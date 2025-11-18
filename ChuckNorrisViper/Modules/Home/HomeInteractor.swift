//
//  HomeInteractor.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation

// MARK: - Interactor Protocol
protocol HomeInteractorProtocol: Sendable {
    func fetchRandomJoke() async throws -> Joke
}

// MARK: - Interactor Implementation
actor HomeInteractor: HomeInteractorProtocol {
    private let jokesService: JokesServiceProtocol

    init(jokesService: JokesServiceProtocol = JokesService()) {
        self.jokesService = jokesService
    }

    func fetchRandomJoke() async throws -> Joke {
        return try await jokesService.getRandomJoke()
    }
}
