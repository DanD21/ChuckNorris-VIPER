//
//  MockCategoriesInteractor.swift
//  ChuckNorrisViperTests
//
//  Mock interactor for testing CategoriesPresenter
//

import Foundation
@testable import ChuckNorrisViper

actor MockCategoriesInteractor: CategoriesInteractorProtocol {
    var shouldThrowError = false
    var errorToThrow: Error = URLError(.badServerResponse)
    var categoriesToReturn: Categories = ["dev", "movie", "food"]
    var jokeToReturn: Joke?

    var fetchCategoriesCalled = false
    var fetchJokeByCategoryCalled = false
    var lastCategoryRequested: String?

    func fetchCategories() async throws -> Categories {
        fetchCategoriesCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        return categoriesToReturn
    }

    func fetchJokeByCategory(_ category: String) async throws -> Joke {
        fetchJokeByCategoryCalled = true
        lastCategoryRequested = category

        if shouldThrowError {
            throw errorToThrow
        }

        return jokeToReturn ?? Joke(
            id: "category-mock",
            value: "Chuck Norris doesn't need categories. Categories need him.",
            iconURL: nil,
            url: nil,
            categories: [category]
        )
    }

    func reset() {
        shouldThrowError = false
        fetchCategoriesCalled = false
        fetchJokeByCategoryCalled = false
        lastCategoryRequested = nil
        jokeToReturn = nil
        categoriesToReturn = ["dev", "movie", "food"]
    }
}
