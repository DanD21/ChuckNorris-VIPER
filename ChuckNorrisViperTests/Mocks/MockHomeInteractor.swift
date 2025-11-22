//
//  MockHomeInteractor.swift
//  ChuckNorrisViperTests
//
//  Mock interactor for testing HomePresenter
//

import Foundation
@testable import ChuckNorrisViper

actor MockHomeInteractor: HomeInteractorProtocol {
    var shouldThrowError = false
    var errorToThrow: Error = URLError(.badServerResponse)
    var jokeToReturn: Joke?
    var fetchRandomJokeCalled = false

    func fetchRandomJoke() async throws -> Joke {
        fetchRandomJokeCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        return jokeToReturn ?? Joke(
            id: "mock-joke",
            value: "Chuck Norris doesn't mock. He creates reality.",
            iconURL: nil,
            url: nil,
            categories: nil
        )
    }

    func reset() {
        shouldThrowError = false
        fetchRandomJokeCalled = false
        jokeToReturn = nil
    }
}
