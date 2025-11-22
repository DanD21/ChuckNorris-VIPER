//
//  SearchView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                // Search results
                if viewModel.isSearching {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
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
                } else if !viewModel.searchResults.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.searchResults) { joke in
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
        .searchable(text: $viewModel.searchQuery, prompt: "Search jokes...")
        .onChange(of: viewModel.searchQuery) { _, _ in
            viewModel.search()
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
