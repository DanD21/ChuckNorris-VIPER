//
//  SearchViewModelTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for SearchViewModel
//

import XCTest
@testable import ChuckNorrisViper

@MainActor
final class SearchViewModelTests: XCTestCase {
    var sut: SearchViewModel!
    var mockService: MockJokesService!

    override func setUp() async throws {
        mockService = MockJokesService()
        sut = SearchViewModel(jokesService: mockService)
    }

    override func tearDown() async throws {
        await mockService.reset()
        sut = nil
        mockService = nil
    }

    func testInitialState() {
        XCTAssertTrue(sut.searchQuery.isEmpty)
        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertFalse(sut.isSearching)
        XCTAssertNil(sut.errorMessage)
    }

    func testSearch_Success() async {
        // Given
        sut.searchQuery = "developer"

        // When
        sut.search()
        try? await Task.sleep(nanoseconds: 600_000_000) // Wait for debounce

        // Then
        XCTAssertFalse(sut.searchResults.isEmpty)
        XCTAssertFalse(sut.isSearching)
        XCTAssertNil(sut.errorMessage)
    }

    func testSearch_EmptyQuery() {
        // Given
        sut.searchQuery = "   "

        // When
        sut.search()

        // Then
        XCTAssertTrue(sut.searchResults.isEmpty)
    }

    func testClearSearch() {
        // Given
        sut.searchQuery = "test"
        sut.searchResults = [Joke(id: "1", value: "test", iconURL: nil, url: nil, categories: nil)]

        // When
        sut.clearSearch()

        // Then
        XCTAssertTrue(sut.searchQuery.isEmpty)
        XCTAssertTrue(sut.searchResults.isEmpty)
        XCTAssertNil(sut.errorMessage)
    }
}
