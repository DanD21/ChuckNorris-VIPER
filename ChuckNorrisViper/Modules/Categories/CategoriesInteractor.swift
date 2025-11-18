//
//  CategoriesInteractor.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation

// MARK: - Interactor Protocol
protocol CategoriesInteractorProtocol: Sendable {
    func fetchCategories() async throws -> Categories
    func fetchJokeByCategory(_ category: String) async throws -> Joke
}

// MARK: - Interactor Implementation
actor CategoriesInteractor: CategoriesInteractorProtocol {
    private let jokesService: JokesServiceProtocol

    init(jokesService: JokesServiceProtocol = JokesService()) {
        self.jokesService = jokesService
    }

    func fetchCategories() async throws -> Categories {
        return try await jokesService.getCategories()
    }

    func fetchJokeByCategory(_ category: String) async throws -> Joke {
        return try await jokesService.getJokeByCategory(category)
    }
}
