//
//  CategoriesViewModel.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import Foundation
import Combine
import SwiftUI

@MainActor
class CategoriesViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var selectedCategory: String?
    @Published var categoryJoke: Joke?
    @Published var isLoading = false
    @Published var isLoadingJoke = false
    @Published var errorMessage: String?

    private let jokesService: JokesServiceProtocol

    init(jokesService: JokesServiceProtocol = JokesService()) {
        self.jokesService = jokesService
    }

    func loadCategories() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let fetchedCategories = try await jokesService.getCategories()
                categories = fetchedCategories.sorted()
            } catch {
                errorMessage = "Failed to load categories: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    func loadJoke(for category: String) {
        Task {
            isLoadingJoke = true
            errorMessage = nil
            selectedCategory = category

            do {
                let joke = try await jokesService.getJokeByCategory(category)
                categoryJoke = joke
            } catch {
                errorMessage = "Failed to load joke: \(error.localizedDescription)"
            }

            isLoadingJoke = false
        }
    }
}
