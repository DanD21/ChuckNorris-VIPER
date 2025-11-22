//
//  MockCategoriesRouter.swift
//  ChuckNorrisViperTests
//
//  Mock router for testing CategoriesPresenter
//

import Foundation
@testable import ChuckNorrisViper

@MainActor
class MockCategoriesRouter: CategoriesRouterProtocol {
    var showJokeDetailCalled = false
    var lastCategoryShown: String?
    var lastJokeShown: Joke?

    func showJokeDetail(for category: String, joke: Joke) {
        showJokeDetailCalled = true
        lastCategoryShown = category
        lastJokeShown = joke
    }

    func reset() {
        showJokeDetailCalled = false
        lastCategoryShown = nil
        lastJokeShown = nil
    }
}
