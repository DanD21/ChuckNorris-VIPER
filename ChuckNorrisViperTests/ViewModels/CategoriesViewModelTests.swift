//
//  CategoriesViewModelTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for CategoriesViewModel
//

import XCTest
@testable import ChuckNorrisViper

@MainActor
final class CategoriesViewModelTests: XCTestCase {
    var sut: CategoriesViewModel!
    var mockService: MockJokesService!

    override func setUp() async throws {
        mockService = MockJokesService()
        sut = CategoriesViewModel(jokesService: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        sut = nil
        mockService = nil
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertTrue(sut.categories.isEmpty, "Categories should be empty initially")
        XCTAssertNil(sut.selectedCategory, "Selected category should be nil initially")
        XCTAssertNil(sut.categoryJoke, "Category joke should be nil initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertFalse(sut.isLoadingJoke, "Should not be loading joke initially")
        XCTAssertNil(sut.errorMessage, "Error message should be nil initially")
    }

    // MARK: - Load Categories Tests

    func testLoadCategories_Success() async {
        // Given
        let expectedCategories = ["dev", "movie", "food", "sport"]
        await mockService.setCategoriesToReturn(expectedCategories)

        // When
        sut.loadCategories()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let serviceCalled = await mockService.getCategoriesCalled
        XCTAssertTrue(serviceCalled, "Service should be called")
        XCTAssertEqual(sut.categories.count, expectedCategories.count)
        XCTAssertEqual(sut.categories.sorted(), expectedCategories.sorted())
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertNil(sut.errorMessage, "Error message should be nil on success")
    }

    func testLoadCategories_SortsAlphabetically() async {
        // Given
        let unsortedCategories = ["zebra", "apple", "monkey", "banana"]
        await mockService.setCategoriesToReturn(unsortedCategories)

        // When
        sut.loadCategories()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.categories, ["apple", "banana", "monkey", "zebra"])
    }

    func testLoadCategories_Failure() async {
        // Given
        await mockService.setShouldThrowError(true)

        // When
        sut.loadCategories()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.errorMessage, "Error message should be set on failure")
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load categories") ?? false)
        XCTAssertTrue(sut.categories.isEmpty, "Categories should be empty on failure")
        XCTAssertFalse(sut.isLoading, "Should not be loading after error")
    }

    // MARK: - Load Joke by Category Tests

    func testLoadJoke_Success() async {
        // Given
        let category = "dev"
        let expectedJoke = Joke(
            id: "dev-joke",
            value: "Chuck Norris doesn't use debuggers. He stares down the bugs until they confess.",
            iconURL: nil,
            url: nil,
            categories: [category]
        )
        await mockService.setJokeToReturn(expectedJoke)

        // When
        sut.loadJoke(for: category)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let serviceCalled = await mockService.getJokeByCategoryCalled
        let lastCategory = await mockService.lastCategoryRequested
        XCTAssertTrue(serviceCalled, "Service should be called")
        XCTAssertEqual(lastCategory, category, "Should request correct category")
        XCTAssertEqual(sut.selectedCategory, category)
        XCTAssertEqual(sut.categoryJoke?.id, expectedJoke.id)
        XCTAssertFalse(sut.isLoadingJoke, "Should not be loading after completion")
    }

    func testLoadJoke_SetsLoadingState() {
        // When
        sut.loadJoke(for: "dev")

        // Then (check immediately)
        XCTAssertTrue(sut.isLoadingJoke, "Should be loading during request")
        XCTAssertEqual(sut.selectedCategory, "dev")
    }

    func testLoadJoke_Failure() async {
        // Given
        await mockService.setShouldThrowError(true)

        // When
        sut.loadJoke(for: "movie")
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.errorMessage, "Error message should be set on failure")
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load joke") ?? false)
        XCTAssertFalse(sut.isLoadingJoke, "Should not be loading after error")
    }

    func testLoadJoke_ClearsErrorOnSuccess() async {
        // Given - first attempt fails
        await mockService.setShouldThrowError(true)
        sut.loadJoke(for: "dev")
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotNil(sut.errorMessage)

        // When - second attempt succeeds
        await mockService.setShouldThrowError(false)
        sut.loadJoke(for: "movie")
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNil(sut.errorMessage, "Error should be cleared on success")
        XCTAssertNotNil(sut.categoryJoke, "Joke should be loaded")
    }
}

// MARK: - MockJokesService Extensions
extension MockJokesService {
    func setCategoriesToReturn(_ categories: Categories) {
        categoriesToReturn = categories
    }
}
