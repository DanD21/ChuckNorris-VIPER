//
//  FavoritesInteractor.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import SwiftData

// MARK: - Interactor Protocol
protocol FavoritesInteractorProtocol: Sendable {
    func fetchFavorites(context: ModelContext) async throws -> [FavoriteJoke]
    func removeFavorite(_ favorite: FavoriteJoke, context: ModelContext) async throws
}

// MARK: - Interactor Implementation
actor FavoritesInteractor: FavoritesInteractorProtocol {
    func fetchFavorites(context: ModelContext) async throws -> [FavoriteJoke] {
        let descriptor = FetchDescriptor<FavoriteJoke>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func removeFavorite(_ favorite: FavoriteJoke, context: ModelContext) async throws {
        context.delete(favorite)
        try context.save()
    }
}
