//
//  Joke.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI Migration
//

import Foundation

struct Joke: Codable, Identifiable, Sendable {
    let id: String
    let value: String
    let iconURL: URL?
    let url: URL?
    let categories: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case value
        case iconURL = "icon_url"
        case url
        case categories
    }
}

struct JokeResponse: Codable, Sendable {
    let total: Int?
    let result: [Joke]?
}
