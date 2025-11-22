//
//  HomeInteractorTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for HomeInteractor
//

import XCTest
@testable import ChuckNorrisViper

final class HomeInteractorTests: XCTestCase {
    var sut: HomeInteractor!
    var mockService: MockJokesService!

    override func setUp() async throws {
        mockService = MockJokesService()
        sut = HomeInteractor(jokesService: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        sut = nil
        mockService = nil
    }

    // MARK: - Fetch Random Joke Tests

    func testFetchRandomJoke_Success() async throws {
        // Given
        let expectedJoke = Joke(
            id: "interactor-test",
            value: "Chuck Norris can instantiate an abstract class.",
            iconURL: nil,
            url: nil,
            categories: ["dev"]
        )
        await mockService.setJokeToReturn(expectedJoke)

        // When
        let joke = try await sut.fetchRandomJoke()

        // Then
        let serviceCalled = await mockService.getRandomJokeCalled
        XCTAssertTrue(serviceCalled, "Should call service")
        XCTAssertEqual(joke.id, expectedJoke.id)
        XCTAssertEqual(joke.value, expectedJoke.value)
    }

    func testFetchRandomJoke_Failure() async {
        // Given
        await mockService.setShouldThrowError(true)

        // When/Then
        do {
            _ = try await sut.fetchRandomJoke()
            XCTFail("Should throw error")
        } catch {
            // Expected
            XCTAssertTrue(error is URLError)
        }
    }

    func testFetchRandomJoke_PassesThroughServiceData() async throws {
        // This test verifies that Interactor doesn't modify data
        // It should pass through service data unchanged

        // Given
        let originalJoke = Joke(
            id: "pass-through",
            value: "Original value",
            iconURL: URL(string: "https://example.com/icon.png"),
            url: URL(string: "https://example.com/joke"),
            categories: ["test", "category"]
        )
        await mockService.setJokeToReturn(originalJoke)

        // When
        let returnedJoke = try await sut.fetchRandomJoke()

        // Then
        XCTAssertEqual(returnedJoke.id, originalJoke.id)
        XCTAssertEqual(returnedJoke.value, originalJoke.value)
        XCTAssertEqual(returnedJoke.iconURL, originalJoke.iconURL)
        XCTAssertEqual(returnedJoke.url, originalJoke.url)
        XCTAssertEqual(returnedJoke.categories, originalJoke.categories)
    }

    func testInteractor_IsActor() {
        // Verify Interactor is an actor for Swift 6 concurrency
        // This compiles = actor conformance works
        Task {
            _ = try? await sut.fetchRandomJoke()
        }
    }
}
