//
//  FavoritesView.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @StateObject private var presenter: FavoritesPresenter
    @Environment(\.modelContext) private var modelContext

    init(presenter: FavoritesPresenter = FavoritesPresenter()) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if presenter.favorites.isEmpty {
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
                        ForEach(presenter.favorites) { favorite in
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
            presenter.viewDidLoad(context: modelContext)
        }
    }
}

// MARK: - Builder
enum FavoritesBuilder {
    static func build() -> FavoritesView {
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter(interactor: interactor)
        return FavoritesView(presenter: presenter)
    }
}

#Preview {
    NavigationStack {
        FavoritesBuilder.build()
            .modelContainer(for: [FavoriteJoke.self, JokeHistory.self])
    }
}
