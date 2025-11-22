//
//  CategoriesInteractorTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for CategoriesInteractor
//

import XCTest
@testable import ChuckNorrisViper

final class CategoriesInteractorTests: XCTestCase {
    var sut: CategoriesInteractor!
    var mockService: MockJokesService!

    override func setUp() async throws {
        mockService = MockJokesService()
        sut = CategoriesInteractor(jokesService: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        sut = nil
        mockService = nil
    }

    // MARK: - Fetch Categories Tests

    func testFetchCategories_Success() async throws {
        // Given
        let expectedCategories = ["dev", "movie", "food", "sport"]
        await mockService.setCategoriesToReturn(expectedCategories)

        // When
        let categories = try await sut.fetchCategories()

        // Then
        let serviceCalled = await mockService.getCategoriesCalled
        XCTAssertTrue(serviceCalled, "Should call service")
        XCTAssertEqual(categories.count, expectedCategories.count)
        XCTAssertEqual(Set(categories), Set(expectedCategories))
    }

    func testFetchCategories_Failure() async {
        // Given
        await mockService.setShouldThrowError(true)

        // When/Then
        do {
            _ = try await sut.fetchCategories()
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func testFetchCategories_PassesThroughServiceData() async throws {
        // Given
        let originalCategories = ["alpha", "beta", "gamma", "delta"]
        await mockService.setCategoriesToReturn(originalCategories)

        // When
        let returnedCategories = try await sut.fetchCategories()

        // Then - Interactor should not modify data
        XCTAssertEqual(Set(returnedCategories), Set(originalCategories))
    }

    // MARK: - Fetch Joke By Category Tests

    func testFetchJokeByCategory_Success() async throws {
        // Given
        let category = "dev"
        let expectedJoke = Joke(
            id: "category-test",
            value: "Chuck Norris can access private methods.",
            iconURL: nil,
            url: nil,
            categories: [category]
        )
        await mockService.setJokeToReturn(expectedJoke)

        // When
        let joke = try await sut.fetchJokeByCategory(category)

        // Then
        let serviceCalled = await mockService.getJokeByCategoryCalled
        let lastCategory = await mockService.lastCategoryRequested
        XCTAssertTrue(serviceCalled, "Should call service")
        XCTAssertEqual(lastCategory, category)
        XCTAssertEqual(joke.id, expectedJoke.id)
        XCTAssertEqual(joke.value, expectedJoke.value)
    }

    func testFetchJokeByCategory_Failure() async {
        // Given
        await mockService.setShouldThrowError(true)

        // When/Then
        do {
            _ = try await sut.fetchJokeByCategory("movie")
            XCTFail("Should throw error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func testFetchJokeByCategory_PassesThroughCategory() async throws {
        // Given
        let testCategories = ["dev", "movie", "food"]

        for category in testCategories {
            // When
            await mockService.reset()
            _ = try? await sut.fetchJokeByCategory(category)

            // Then
            let lastCategory = await mockService.lastCategoryRequested
            XCTAssertEqual(lastCategory, category, "Should pass through category unchanged")
        }
    }

    func testInteractor_IsActor() {
        // Verify Interactor is an actor for Swift 6 concurrency
        Task {
            _ = try? await sut.fetchCategories()
            _ = try? await sut.fetchJokeByCategory("dev")
        }
    }
}
