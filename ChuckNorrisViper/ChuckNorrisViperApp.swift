//
//  ChuckNorrisViperApp.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - MVVM Architecture
//

import SwiftUI
import SwiftData

@main
struct ChuckNorrisViperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteJoke.self,
            JokeHistory.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
