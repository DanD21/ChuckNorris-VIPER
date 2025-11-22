//
//  FavoritesView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if viewModel.favorites.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No Favorites Yet")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Favorite jokes will appear here")
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.favorites) { favorite in
                            JokeCard(joke: favorite.toJoke(), modelContext: modelContext)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            viewModel.loadFavorites(context: modelContext)
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
            .modelContainer(for: [FavoriteJoke.self, JokeHistory.self])
    }
}
