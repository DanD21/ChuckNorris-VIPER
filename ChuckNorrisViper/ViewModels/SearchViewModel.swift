//
//  SearchViewModel.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: [Joke] = []
    @Published var isSearching = false
    @Published var errorMessage: String?

    private let jokesService: JokesServiceProtocol
    private var searchTask: Task<Void, Never>?

    init(jokesService: JokesServiceProtocol = JokesService()) {
        self.jokesService = jokesService
    }

    func search() {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        // Cancel previous search
        searchTask?.cancel()

        searchTask = Task {
            isSearching = true
            errorMessage = nil

            // Debounce
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            guard !Task.isCancelled else {
                isSearching = false
                return
            }

            do {
                let results = try await jokesService.searchJokes(query: searchQuery)
                if !Task.isCancelled {
                    searchResults = results
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = "Search failed: \(error.localizedDescription)"
                }
            }

            isSearching = false
        }
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = []
        errorMessage = nil
        searchTask?.cancel()
    }
}
