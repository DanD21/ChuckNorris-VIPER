//
//  CategoriesPresenterTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for CategoriesPresenter
//

import XCTest
@testable import ChuckNorrisViper

@MainActor
final class CategoriesPresenterTests: XCTestCase {
    var sut: CategoriesPresenter!
    var mockInteractor: MockCategoriesInteractor!
    var mockRouter: MockCategoriesRouter!

    override func setUp() async throws {
        mockInteractor = MockCategoriesInteractor()
        mockRouter = MockCategoriesRouter()
        sut = CategoriesPresenter(interactor: mockInteractor, router: mockRouter)
    }

    override func tearDown() async throws {
        await mockInteractor.reset()
        mockRouter.reset()
        sut = nil
        mockInteractor = nil
        mockRouter = nil
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

    // MARK: - View Did Load Tests

    func testViewDidLoad_LoadsCategories() async {
        // When
        sut.viewDidLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let interactorCalled = await mockInteractor.fetchCategoriesCalled
        XCTAssertTrue(interactorCalled, "Should call interactor on view did load")
        XCTAssertFalse(sut.categories.isEmpty, "Should load categories")
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    // MARK: - Load Categories Tests

    func testLoadCategories_Success() async {
        // Given
        let expectedCategories = ["dev", "movie", "food", "sport"]
        await mockInteractor.setCategories(expectedCategories)

        // When
        sut.viewDidLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.categories.count, expectedCategories.count)
        XCTAssertEqual(sut.categories.sorted(), expectedCategories.sorted())
        XCTAssertNil(sut.errorMessage)
    }

    func testLoadCategories_SortsAlphabetically() async {
        // Given
        let unsortedCategories = ["zebra", "apple", "monkey"]
        await mockInteractor.setCategories(unsortedCategories)

        // When
        sut.viewDidLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.categories, ["apple", "monkey", "zebra"])
    }

    func testLoadCategories_Failure() async {
        // Given
        await mockInteractor.setShouldThrowError(true)

        // When
        sut.viewDidLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load categories") ?? false)
        XCTAssertTrue(sut.categories.isEmpty)
    }

    // MARK: - Did Select Category Tests

    func testDidSelectCategory_LoadsJoke() async {
        // Given
        let category = "dev"

        // When
        sut.didSelectCategory(category)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let interactorCalled = await mockInteractor.fetchJokeByCategoryCalled
        let lastCategory = await mockInteractor.lastCategoryRequested
        XCTAssertTrue(interactorCalled, "Should call interactor")
        XCTAssertEqual(lastCategory, category)
        XCTAssertEqual(sut.selectedCategory, category)
        XCTAssertNotNil(sut.categoryJoke)
    }

    func testDidSelectCategory_NavigatesToDetail() async {
        // Given
        let category = "movie"
        let expectedJoke = Joke(
            id: "movie-joke",
            value: "Chuck Norris movies have no plot. Just fatalities.",
            iconURL: nil,
            url: nil,
            categories: [category]
        )
        await mockInteractor.setJoke(expectedJoke)

        // When
        sut.didSelectCategory(category)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertTrue(mockRouter.showJokeDetailCalled, "Should navigate to joke detail")
        XCTAssertEqual(mockRouter.lastCategoryShown, category)
        XCTAssertEqual(mockRouter.lastJokeShown?.id, expectedJoke.id)
    }

    func testDidSelectCategory_SetsLoadingState() {
        // When
        sut.didSelectCategory("dev")

        // Then (immediate check)
        XCTAssertTrue(sut.isLoadingJoke, "Should be loading joke during request")
        XCTAssertEqual(sut.selectedCategory, "dev")
    }

    func testDidSelectCategory_Failure() async {
        // Given
        await mockInteractor.setShouldThrowError(true)

        // When
        sut.didSelectCategory("food")
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load joke") ?? false)
        XCTAssertFalse(sut.isLoadingJoke)
        XCTAssertFalse(mockRouter.showJokeDetailCalled, "Should not navigate on error")
    }

    func testDidSelectCategory_ClearsErrorOnRetry() async {
        // Given - first attempt fails
        await mockInteractor.setShouldThrowError(true)
        sut.didSelectCategory("dev")
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotNil(sut.errorMessage)

        // When - retry succeeds
        await mockInteractor.setShouldThrowError(false)
        sut.didSelectCategory("movie")
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNil(sut.errorMessage, "Error should be cleared on successful retry")
        XCTAssertNotNil(sut.categoryJoke)
    }

    // MARK: - VIPER Layer Tests

    func testPresenter_UsesInteractorNotService() async {
        // Verify proper VIPER layering

        // When
        sut.viewDidLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let interactorCalled = await mockInteractor.fetchCategoriesCalled
        XCTAssertTrue(interactorCalled, "Presenter should use Interactor, not Service directly")
    }

    func testPresenter_UsesRouterForNavigation() async {
        // When
        sut.didSelectCategory("dev")
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertTrue(mockRouter.showJokeDetailCalled, "Presenter should use Router for navigation")
    }
}

// MARK: - Mock Extensions
extension MockCategoriesInteractor {
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func setCategories(_ categories: Categories) {
        categoriesToReturn = categories
    }

    func setJoke(_ joke: Joke) {
        jokeToReturn = joke
    }
}
