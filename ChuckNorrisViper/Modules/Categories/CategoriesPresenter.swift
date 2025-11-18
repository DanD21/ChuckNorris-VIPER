//
//  CategoriesPresenter.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import Combine
import SwiftUI

// MARK: - Presenter Protocol
protocol CategoriesPresenterProtocol: ObservableObject {
    var categories: [String] { get }
    var selectedCategory: String? { get }
    var categoryJoke: Joke? { get }
    var isLoading: Bool { get }
    var isLoadingJoke: Bool { get }
    var errorMessage: String? { get }

    func viewDidLoad()
    func didSelectCategory(_ category: String)
}

// MARK: - Presenter Implementation
@MainActor
class CategoriesPresenter: CategoriesPresenterProtocol {
    @Published var categories: [String] = []
    @Published var selectedCategory: String?
    @Published var categoryJoke: Joke?
    @Published var isLoading = false
    @Published var isLoadingJoke = false
    @Published var errorMessage: String?

    private let interactor: CategoriesInteractorProtocol
    private let router: CategoriesRouterProtocol

    init(interactor: CategoriesInteractorProtocol = CategoriesInteractor(),
         router: CategoriesRouterProtocol = CategoriesRouter()) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        loadCategories()
    }

    func didSelectCategory(_ category: String) {
        loadJoke(for: category)
    }

    private func loadCategories() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let fetchedCategories = try await interactor.fetchCategories()
                categories = fetchedCategories.sorted()
            } catch {
                errorMessage = "Failed to load categories: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    private func loadJoke(for category: String) {
        Task {
            isLoadingJoke = true
            errorMessage = nil
            selectedCategory = category

            do {
                let joke = try await interactor.fetchJokeByCategory(category)
                categoryJoke = joke
                router.showJokeDetail(for: category, joke: joke)
            } catch {
                errorMessage = "Failed to load joke: \(error.localizedDescription)"
            }

            isLoadingJoke = false
        }
    }
}
