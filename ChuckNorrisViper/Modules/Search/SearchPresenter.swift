//
//  SearchPresenter.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import Foundation
import Combine
import SwiftUI

// MARK: - Presenter Protocol
protocol SearchPresenterProtocol: ObservableObject {
    var searchQuery: String { get set }
    var searchResults: [Joke] { get }
    var isSearching: Bool { get }
    var errorMessage: String? { get }

    func viewDidLoad()
    func didChangeSearchQuery(_ query: String)
    func clearSearch()
}

// MARK: - Presenter Implementation
@MainActor
class SearchPresenter: SearchPresenterProtocol {
    @Published var searchQuery = ""
    @Published var searchResults: [Joke] = []
    @Published var isSearching = false
    @Published var errorMessage: String?

    private let interactor: SearchInteractorProtocol
    private var searchTask: Task<Void, Never>?

    init(interactor: SearchInteractorProtocol = SearchInteractor()) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        // Nothing to load initially
    }

    func didChangeSearchQuery(_ query: String) {
        searchQuery = query

        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            searchTask?.cancel()
            return
        }

        // Cancel previous search
        searchTask?.cancel()

        searchTask = Task {
            isSearching = true
            errorMessage = nil

            // Debounce
            try? await Task.sleep(nanoseconds: 500_000_000)

            guard !Task.isCancelled else {
                isSearching = false
                return
            }

            do {
                let results = try await interactor.searchJokes(query: query)
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
