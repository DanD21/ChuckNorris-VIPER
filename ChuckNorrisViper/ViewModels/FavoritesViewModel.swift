//
//  FavoritesViewModel.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteJoke] = []
    @Published var errorMessage: String?

    private var modelContext: ModelContext?

    func loadFavorites(context: ModelContext) {
        self.modelContext = context

        do {
            let descriptor = FetchDescriptor<FavoriteJoke>(
                sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
            )
            favorites = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load favorites: \(error.localizedDescription)"
        }
    }

    func removeFavorite(_ favorite: FavoriteJoke) {
        guard let context = modelContext else { return }

        context.delete(favorite)

        do {
            try context.save()
            loadFavorites(context: context)
        } catch {
            errorMessage = "Failed to remove favorite: \(error.localizedDescription)"
        }
    }
}
