//
//  SearchView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @StateObject private var presenter: SearchPresenter
    @Environment(\.modelContext) private var modelContext

    init(presenter: SearchPresenter = SearchPresenter()) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                if presenter.isSearching {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if let error = presenter.errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else if presenter.searchResults.isEmpty && !presenter.searchQuery.isEmpty {
                    Spacer()
                    VStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No jokes found")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Text("Try a different search term")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    Spacer()
                } else if !presenter.searchResults.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(presenter.searchResults) { joke in
                                JokeCard(joke: joke, modelContext: modelContext)
                            }
                        }
                        .padding()
                    }
                } else {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Search Chuck Norris Jokes")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Enter keywords to find jokes")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .searchable(text: $presenter.searchQuery, prompt: "Search jokes...")
        .onChange(of: presenter.searchQuery) { _, newValue in
            presenter.didChangeSearchQuery(newValue)
        }
        .onAppear {
            presenter.viewDidLoad()
        }
    }
}

// MARK: - Builder
enum SearchBuilder {
    static func build() -> SearchView {
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(interactor: interactor)
        return SearchView(presenter: presenter)
    }
}

#Preview {
    NavigationStack {
        SearchBuilder.build()
            .modelContainer(for: [FavoriteJoke.self, JokeHistory.self])
    }
}
