//
//  HomeInteractorTests.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 23/11/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import XCTest
import RxSwift
@testable import ChuckNorrisViper

class HomeInteractorTests: XCTestCase {

    var interactor: HomeInteractorImpl!
    var jokesService: MockJokesService!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.interactor = HomeInteractorImpl.init()
        self.jokesService = MockJokesService.init()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetRandomJoke() {
        let disposeBag = DisposeBag()
        let joke = self.interactor.getRandomJoke()
        joke
            .observeOn(MainScheduler.instance)
            .do(onNext: { (joke) in
                
                XCTAssertNotNil(joke, "No joke recieved")
                
            }).subscribe()
            .disposed(by: disposeBag)
    }

    class MockJokesService: JokesService {
        func getRandomJoke() -> Observable<Joke> {
            let joke = Joke(json: ["value": "Joke from tests"])!
            return Observable.just(joke)
        }

        func getCategories() -> Observable<ChuckNorrisViper.Category> {
            let category = Category(json: ["dev", "sport"])!
            return Observable.just(category)
        }

        func getJokeByCategory(category: String) -> Observable<Joke> {
            let joke = Joke(json: ["value": "Joke from tests"])!
            return Observable.just(joke)
        }

    }

}
