//
//  HomePresenterTests.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 23/11/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import RxSwift
import XCTest
@testable import ChuckNorrisViper

class HomePresenterTest: XCTestCase {

    var presenter: HomePresenterImpl!
    var view = MockViewController()

    override func setUp() {
        super.setUp()

        presenter = HomePresenterImpl()
        presenter.interactor = MockInteractor()
        presenter.router = MockRouter()
        presenter.view = view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetRandomJoke() {
        self.presenter.randomButtonPressed()
        XCTAssertTrue(self.view.jokeIsShowed, "Joke not shown")
    }

    func testGetRandomJokeError() {
        self.presenter.interactor = MockInteractorError()
        self.presenter.randomButtonPressed()
        XCTAssertTrue(self.view.errorShowed, "Error message not shown")
    }

    class MockInteractor: HomeInteractor {
        func getRandomJoke() -> Observable<Joke> {
            return Observable.create({ (observer) -> Disposable in
                observer.onNext(Joke(json: ["value": "Joke from tests"])!)
//                observer.onCompleted()
                return Disposables.create()
            })
        }

        func getCategories() -> Observable<ChuckNorrisViper.Category> {
            return Observable.create({ (observer) -> Disposable in
                return Disposables.create()
            })
        }

        func getJokeByCategory(category: String) -> Observable<Joke> {
            return Observable.create({ (observer) -> Disposable in
                return Disposables.create()
            })
        }
    }

    class MockInteractorError: HomeInteractor {
        func getRandomJoke() -> Observable<Joke> {
            return Observable.create({ (observer) -> Disposable in
                observer.onError(NSError.init(domain: "hell.com", code: 666, userInfo: nil))
                return Disposables.create()
            })
        }

        func getCategories() -> Observable<ChuckNorrisViper.Category> {
            return Observable.create({ (observer) -> Disposable in
                return Disposables.create()
            })
        }

        func getJokeByCategory(category: String) -> Observable<Joke> {
            return Observable.create({ (observer) -> Disposable in
                return Disposables.create()
            })
        }
    }

    class MockRouter: HomeRouter {
        func showCategoriesTable() {

        }
    }

    class MockViewController: HomeView {
        var jokeIsShowed = false
        var errorShowed = false

        func showJoke(joke: Joke) {
            jokeIsShowed = true
        }

        func showError() {
            errorShowed = true
        }

        func showCategories(categories: ChuckNorrisViper.Category) {

        }
    }
}
