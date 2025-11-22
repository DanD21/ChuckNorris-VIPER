//
//  HomePresenterTests.swift
//  ChuckNorrisViperTests
//
//  Unit tests for HomePresenter
//

import XCTest
@testable import ChuckNorrisViper

@MainActor
final class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var mockInteractor: MockHomeInteractor!
    var mockRouter: MockHomeRouter!

    override func setUp() async throws {
        mockInteractor = MockHomeInteractor()
        mockRouter = MockHomeRouter()
        sut = HomePresenter(interactor: mockInteractor, router: mockRouter)
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
        XCTAssertNil(sut.currentJoke, "Current joke should be nil initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertNil(sut.errorMessage, "Error message should be nil initially")
    }

    // MARK: - View Did Load Tests

    func testViewDidLoad_LoadsJoke() async {
        // When
        sut.viewDidLoad()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let interactorCalled = await mockInteractor.fetchRandomJokeCalled
        XCTAssertTrue(interactorCalled, "Should call interactor on view did load")
        XCTAssertNotNil(sut.currentJoke, "Should load joke")
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    // MARK: - Did Tap Random Joke Tests

    func testDidTapRandomJoke_Success() async {
        // Given
        let expectedJoke = Joke(
            id: "roundhouse",
            value: "Chuck Norris can divide by zero.",
            iconURL: nil,
            url: nil,
            categories: nil
        )
        await mockInteractor.setJoke(expectedJoke)

        // When
        sut.didTapRandomJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let interactorCalled = await mockInteractor.fetchRandomJokeCalled
        XCTAssertTrue(interactorCalled, "Should call interactor")
        XCTAssertEqual(sut.currentJoke?.id, expectedJoke.id)
        XCTAssertEqual(sut.currentJoke?.value, expectedJoke.value)
        XCTAssertNil(sut.errorMessage, "Should have no error on success")
    }

    func testDidTapRandomJoke_SetsLoadingState() {
        // When
        sut.didTapRandomJoke()

        // Then (immediate check)
        XCTAssertTrue(sut.isLoading, "Should be loading during request")
    }

    func testDidTapRandomJoke_Failure() async {
        // Given
        await mockInteractor.setShouldThrowError(true)

        // When
        sut.didTapRandomJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNotNil(sut.errorMessage, "Should have error message on failure")
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load joke") ?? false)
        XCTAssertFalse(sut.isLoading, "Should not be loading after error")
    }

    func testDidTapRandomJoke_ClearsErrorOnRetry() async {
        // Given - first attempt fails
        await mockInteractor.setShouldThrowError(true)
        sut.didTapRandomJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotNil(sut.errorMessage)

        // When - retry succeeds
        await mockInteractor.setShouldThrowError(false)
        sut.didTapRandomJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertNil(sut.errorMessage, "Error should be cleared on successful retry")
        XCTAssertNotNil(sut.currentJoke)
    }

    // MARK: - Did Tap Categories Tests

    func testDidTapCategories_NavigatesToCategories() {
        // When
        sut.didTapCategories()

        // Then
        XCTAssertTrue(mockRouter.navigateToCategoriesCalled, "Should navigate to categories")
    }

    // MARK: - VIPER Layer Tests

    func testPresenter_DoesNotCallServiceDirectly() async {
        // This test verifies proper VIPER layering
        // Presenter should only talk to Interactor, not Service

        // When
        sut.didTapRandomJoke()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        let interactorCalled = await mockInteractor.fetchRandomJokeCalled
        XCTAssertTrue(interactorCalled, "Presenter should use Interactor, not Service directly")
    }
}

// MARK: - MockHomeInteractor Extensions
extension MockHomeInteractor {
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func setJoke(_ joke: Joke) {
        jokeToReturn = joke
    }
}
