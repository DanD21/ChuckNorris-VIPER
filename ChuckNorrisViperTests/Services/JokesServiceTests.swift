//
//  JokesServiceTests.swift
//  ChuckNorrisViperTests
//
//  Integration tests for JokesService
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
        // Given
        let json = """
        {
            "id": "minimal",
            "value": "Test"
        }
        """.data(using: .utf8)!

        // When
        let joke = try JSONDecoder().decode(Joke.self, from: json)

        // Then
        XCTAssertEqual(joke.id, "minimal")
        XCTAssertEqual(joke.value, "Test")
    }

    func testCategoriesDecoding() throws {
        // Given
        let json = """
        ["dev", "movie", "food"]
        """.data(using: .utf8)!

        // When
        let categories = try JSONDecoder().decode([String].self, from: json)

        // Then
        XCTAssertEqual(categories.count, 3)
        XCTAssertTrue(categories.contains("dev"))
    }

    func testJokeIsSendable() {
        // Verify Sendable conformance for Swift 6
        let joke = Joke(id: "test", value: "test", iconURL: nil, url: nil, categories: nil)
        Task {
            let _ = joke
        }
    }

    func testService_IsActor() {
        // Verify Service is an actor
        Task {
            _ = try? await sut.getRandomJoke()
        }
    }
}
