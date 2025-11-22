//
//  MockJokesService.swift
//  ChuckNorrisViperTests
//
//  Mock service for unit testing
//

import Foundation
@testable import ChuckNorrisViper

actor MockJokesService: JokesServiceProtocol {
    var shouldThrowError = false
    var errorToThrow: Error = URLError(.badServerResponse)
    var jokeToReturn: Joke?
    var categoriesToReturn: Categories = []

    var getRandomJokeCalled = false
    var getCategoriesCalled = false
    var getJokeByCategoryCalled = false
    var lastCategoryRequested: String?

    func getRandomJoke() async throws -> Joke {
        getRandomJokeCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        return jokeToReturn ?? Joke(
            id: "test-1",
            value: "Chuck Norris doesn't write tests. His code is already perfect.",
            iconURL: URL(string: "https://api.chucknorris.io/img/avatar/chuck-norris.png"),
            url: URL(string: "https://api.chucknorris.io/jokes/test-1"),
            categories: []
        )
    }

    func getCategories() async throws -> Categories {
        getCategoriesCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        return categoriesToReturn.isEmpty ? ["dev", "movie", "food"] : categoriesToReturn
    }

    func getJokeByCategory(_ category: String) async throws -> Joke {
        getJokeByCategoryCalled = true
        lastCategoryRequested = category

        if shouldThrowError {
            throw errorToThrow
        }

        return jokeToReturn ?? Joke(
            id: "test-category-1",
            value: "Chuck Norris can write infinite recursion functions and have them terminate.",
            iconURL: URL(string: "https://api.chucknorris.io/img/avatar/chuck-norris.png"),
            url: URL(string: "https://api.chucknorris.io/jokes/test-category-1"),
            categories: [category]
        )
    }

    func reset() {
        shouldThrowError = false
        getRandomJokeCalled = false
        getCategoriesCalled = false
        getJokeByCategoryCalled = false
        lastCategoryRequested = nil
        jokeToReturn = nil
        categoriesToReturn = []
    }
}
