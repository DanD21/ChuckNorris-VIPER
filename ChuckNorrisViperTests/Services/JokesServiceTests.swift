//
//  JokesServiceTests.swift
//  ChuckNorrisViperTests
//
//  Integration tests for JokesService
//  Note: These test the real API - use sparingly to avoid rate limits
//

import XCTest
@testable import ChuckNorrisViper

final class JokesServiceTests: XCTestCase {
    var sut: JokesService!

    override func setUp() async throws {
        sut = JokesService()
    }

    override func tearDown() async throws {
        sut = nil
    }

    // MARK: - Real API Integration Tests
    // These are commented out by default to avoid hitting the real API in CI
    // Uncomment locally to verify API integration

    /*
    func testGetRandomJoke_RealAPI() async throws {
        // When
        let joke = try await sut.getRandomJoke()

        // Then
        XCTAssertFalse(joke.id.isEmpty, "Joke should have an ID")
        XCTAssertFalse(joke.value.isEmpty, "Joke should have a value")
    }

    func testGetCategories_RealAPI() async throws {
        // When
        let categories = try await sut.getCategories()

        // Then
        XCTAssertFalse(categories.isEmpty, "Should return categories")
        XCTAssertTrue(categories.contains("dev"), "Should contain 'dev' category")
    }

    func testGetJokeByCategory_RealAPI() async throws {
        // Given
        let category = "dev"

        // When
        let joke = try await sut.getJokeByCategory(category)

        // Then
        XCTAssertFalse(joke.id.isEmpty, "Joke should have an ID")
        XCTAssertFalse(joke.value.isEmpty, "Joke should have a value")
        XCTAssertTrue(joke.categories?.contains(category) ?? false, "Joke should be in requested category")
    }
    */

    // MARK: - Model Decoding Tests

    func testJokeDecoding() throws {
        // Given
        let json = """
        {
            "id": "test-123",
            "value": "Chuck Norris can unit test entire applications with a single assertion.",
            "icon_url": "https://api.chucknorris.io/img/avatar/chuck-norris.png",
            "url": "https://api.chucknorris.io/jokes/test-123",
            "categories": ["dev"]
        }
        """.data(using: .utf8)!

        // When
        let joke = try JSONDecoder().decode(Joke.self, from: json)

        // Then
        XCTAssertEqual(joke.id, "test-123")
        XCTAssertEqual(joke.value, "Chuck Norris can unit test entire applications with a single assertion.")
        XCTAssertNotNil(joke.iconURL)
        XCTAssertNotNil(joke.url)
        XCTAssertEqual(joke.categories?.count, 1)
        XCTAssertEqual(joke.categories?.first, "dev")
    }

    func testJokeDecoding_MinimalJSON() throws {
        // Given - minimal required fields
        let json = """
        {
            "id": "minimal-test",
            "value": "Test joke"
        }
        """.data(using: .utf8)!

        // When
        let joke = try JSONDecoder().decode(Joke.self, from: json)

        // Then
        XCTAssertEqual(joke.id, "minimal-test")
        XCTAssertEqual(joke.value, "Test joke")
        XCTAssertNil(joke.iconURL)
        XCTAssertNil(joke.url)
        XCTAssertNil(joke.categories)
    }

    func testCategoriesDecoding() throws {
        // Given
        let json = """
        ["dev", "movie", "food", "sport"]
        """.data(using: .utf8)!

        // When
        let categories = try JSONDecoder().decode([String].self, from: json)

        // Then
        XCTAssertEqual(categories.count, 4)
        XCTAssertTrue(categories.contains("dev"))
        XCTAssertTrue(categories.contains("movie"))
    }

    func testJokeIsSendable() {
        // Verify Joke conforms to Sendable for Swift 6 concurrency
        let joke = Joke(id: "test", value: "test", iconURL: nil, url: nil, categories: nil)

        // This compiles = Sendable conformance works
        Task {
            let _ = joke
        }
    }
}
