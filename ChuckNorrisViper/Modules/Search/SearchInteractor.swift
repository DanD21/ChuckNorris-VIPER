//
//  SearchInteractor.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation

// MARK: - Interactor Protocol
protocol SearchInteractorProtocol: Sendable {
    func searchJokes(query: String) async throws -> [Joke]
}

// MARK: - Interactor Implementation
actor SearchInteractor: SearchInteractorProtocol {
    private let jokesService: JokesServiceProtocol

    init(jokesService: JokesServiceProtocol = JokesService()) {
        self.jokesService = jokesService
    }

    func searchJokes(query: String) async throws -> [Joke] {
        return try await jokesService.searchJokes(query: query)
    }
}
