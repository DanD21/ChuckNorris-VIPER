//
//  FavoritesPresenter.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Presenter Protocol
protocol FavoritesPresenterProtocol: ObservableObject {
    var favorites: [FavoriteJoke] { get }
    var errorMessage: String? { get }

    func viewDidLoad(context: ModelContext)
    func didTapRemove(_ favorite: FavoriteJoke, context: ModelContext)
}

// MARK: - Presenter Implementation
@MainActor
class FavoritesPresenter: FavoritesPresenterProtocol {
    @Published var favorites: [FavoriteJoke] = []
    @Published var errorMessage: String?

    private let interactor: FavoritesInteractorProtocol

    init(interactor: FavoritesInteractorProtocol = FavoritesInteractor()) {
        self.interactor = interactor
    }

    func viewDidLoad(context: ModelContext) {
        loadFavorites(context: context)
    }

    func didTapRemove(_ favorite: FavoriteJoke, context: ModelContext) {
        Task {
            do {
                try await interactor.removeFavorite(favorite, context: context)
                loadFavorites(context: context)
            } catch {
                errorMessage = "Failed to remove favorite: \(error.localizedDescription)"
            }
        }
    }

    private func loadFavorites(context: ModelContext) {
        Task {
            do {
                let fetchedFavorites = try await interactor.fetchFavorites(context: context)
                favorites = fetchedFavorites
            } catch {
                errorMessage = "Failed to load favorites: \(error.localizedDescription)"
            }
        }
    }
}
