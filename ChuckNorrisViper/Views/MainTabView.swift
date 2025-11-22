//
//  MainTabView.swift
//  ChuckNorrisViper
//
//  Main tab-based navigation
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                CategoriesView()
            }
            .tabItem {
                Label("Categories", systemImage: "list.bullet")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
        .tint(.red)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [FavoriteJoke.self, JokeHistory.self])
}
