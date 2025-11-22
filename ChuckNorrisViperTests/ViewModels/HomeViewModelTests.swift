//
//  HomeViewModelTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for HomeViewModel
//

import XCTest
@testable import ChuckNorrisViper

@MainActor
final class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var mockService: MockJokesService!

    override func setUp() async throws {
        mockService = MockJokesService()
        sut = HomeViewModel(jokesService: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        sut = nil
        mockService = nil
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        // Then
        XCTAssertNil(sut.currentJoke, "Current joke should be nil initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertNil(sut.errorMessage, "Error message should be nil initially")
    }

    // MARK: - Load Random Joke Tests

    func testLoadRandomJoke_Success() async {
        // Given
        let expectedJoke = Joke(
            id: "roundhouse-kick",
            value: "Chuck Norris doesn't need unit tests. His code is always right.",
            iconURL: nil,
            url: nil,
            categories: nil
        )
        await mockService.setJokeToReturn(expectedJoke)

        // When
        sut.loadRandomJoke()

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Then
        let serviceCalled = await mockService.getRandomJokeCalled
        XCTAssertTrue(serviceCalled, "Service should be called")
        XCTAssertEqual(sut.currentJoke?.id, expectedJoke.id)
        XCTAssertEqual(sut.currentJoke?.value, expectedJoke.value)
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertNil(sut.errorMessage, "Error message should be nil on success")
    }

    func testLoadRandomJoke_SetsLoadingState() {
        // When
        sut.loadRandomJoke()

        // Then (check immediately)
        XCTAssertTrue(sut.isLoading, "Should be loading during request")
    }

    func testLoadRandomJoke_Failure() async {
        // Given
        await mockService.setShouldThrowError(true)

        // When
        sut.loadRandomJoke()

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.errorMessage, "Error message should be set on failure")
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load joke") ?? false)
        XCTAssertFalse(sut.isLoading, "Should not be loading after error")
    }

    func testRefreshJoke_LoadsNewJoke() async {
        // Given
        await mockService.reset()

        // When
        sut.refreshJoke()

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let serviceCalled = await mockService.getRandomJokeCalled
        XCTAssertTrue(serviceCalled, "Refresh should trigger joke loading")
    }

    func testMultipleRefreshes_ClearsErrorMessage() async {
        // Given
        await mockService.setShouldThrowError(true)
        sut.loadRandomJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.errorMessage, "Error should be set after first failure")

        // When - second attempt succeeds
        await mockService.setShouldThrowError(false)
        sut.refreshJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNil(sut.errorMessage, "Error should be cleared on successful refresh")
        XCTAssertNotNil(sut.currentJoke, "Joke should be loaded")
    }
}

// MARK: - MockJokesService Extensions
extension MockJokesService {
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func setJokeToReturn(_ joke: Joke) {
        jokeToReturn = joke
    }
}
