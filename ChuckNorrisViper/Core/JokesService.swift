//
//  JokesService.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI Migration - VIPER Version
//

import Foundation
import Combine

// MARK: - Service Protocol
protocol JokesServiceProtocol: Sendable {
    func getRandomJoke() async throws -> Joke
    func getCategories() async throws -> Categories
    func getJokeByCategory(_ category: String) async throws -> Joke
}

// MARK: - Service Implementation
actor JokesService: JokesServiceProtocol {
    private let baseURL = "https://api.chucknorris.io"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getRandomJoke() async throws -> Joke {
        let url = URL(string: "\(baseURL)/jokes/random")!
        let (data, _) = try await session.data(from: url)
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        return joke
    }

    func getCategories() async throws -> Categories {
        let url = URL(string: "\(baseURL)/jokes/categories")!
        let (data, _) = try await session.data(from: url)
        let categories = try JSONDecoder().decode([String].self, from: data)
        return categories
    }

    func getJokeByCategory(_ category: String) async throws -> Joke {
        let urlString = "\(baseURL)/jokes/random?category=\(category)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await session.data(from: url)
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        return joke
    }
}
