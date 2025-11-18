//
//  HomePresenter.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import Combine
import SwiftUI

// MARK: - Presenter Protocol
protocol HomePresenterProtocol: ObservableObject {
    var currentJoke: Joke? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func viewDidLoad()
    func didTapRandomJoke()
    func didTapCategories()
}

// MARK: - Presenter Implementation
@MainActor
class HomePresenter: HomePresenterProtocol {
    @Published var currentJoke: Joke?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterProtocol

    init(interactor: HomeInteractorProtocol = HomeInteractor(),
         router: HomeRouterProtocol = HomeRouter()) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        loadRandomJoke()
    }

    func didTapRandomJoke() {
        loadRandomJoke()
    }

    func didTapCategories() {
        router.navigateToCategories()
    }

    private func loadRandomJoke() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let joke = try await interactor.fetchRandomJoke()
                currentJoke = joke
            } catch {
                errorMessage = "Failed to load joke: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }
}
