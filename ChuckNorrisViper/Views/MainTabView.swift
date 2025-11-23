//
//  MainTabView.swift
//  ChuckNorrisViper
//
//  Main tab-based navigation - VIPER Architecture
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeBuilder.build()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                SearchBuilder.build()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                CategoriesBuilder.build()
            }
            .tabItem {
                Label("Categories", systemImage: "list.bullet")
            }

            NavigationStack {
                FavoritesBuilder.build()
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
