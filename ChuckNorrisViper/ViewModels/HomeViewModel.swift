//
//  HomeViewModel.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import Foundation
import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentJoke: Joke?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let jokesService: JokesServiceProtocol

    init(jokesService: JokesServiceProtocol = JokesService()) {
        self.jokesService = jokesService
    }

    func loadRandomJoke() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let joke = try await jokesService.getRandomJoke()
                currentJoke = joke
            } catch {
                errorMessage = "Failed to load joke: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    func refreshJoke() {
        loadRandomJoke()
    }
}
