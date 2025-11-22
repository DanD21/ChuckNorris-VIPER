//
//  FavoriteJoke.swift
//  ChuckNorrisViper
//
//  SwiftData model for persisting favorite jokes
//

import Foundation
import SwiftData

@Model
final class FavoriteJoke {
    @Attribute(.unique) var id: String
    var value: String
    var iconURL: String?
    var url: String?
    var categories: [String]
    var savedAt: Date

    init(id: String, value: String, iconURL: String? = nil, url: String? = nil, categories: [String] = [], savedAt: Date = Date()) {
        self.id = id
        self.value = value
        self.iconURL = iconURL
        self.url = url
        self.categories = categories
        self.savedAt = savedAt
    }

    convenience init(from joke: Joke) {
        self.init(
            id: joke.id,
            value: joke.value,
            iconURL: joke.iconURL?.absoluteString,
            url: joke.url?.absoluteString,
            categories: joke.categories ?? [],
            savedAt: Date()
        )
    }

    func toJoke() -> Joke {
        Joke(
            id: id,
            value: value,
            iconURL: iconURL.flatMap { URL(string: $0) },
            url: url.flatMap { URL(string: $0) },
            categories: categories.isEmpty ? nil : categories
        )
    }
}

@Model
final class JokeHistory {
    @Attribute(.unique) var id: String
    var value: String
    var viewedAt: Date

    init(id: String, value: String, viewedAt: Date = Date()) {
        self.id = id
        self.value = value
        self.viewedAt = viewedAt
    }

    convenience init(from joke: Joke) {
        self.init(id: joke.id, value: joke.value, viewedAt: Date())
    }
}
