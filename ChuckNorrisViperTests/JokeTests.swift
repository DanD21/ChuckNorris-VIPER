//
//  JokeTests.swift
//  ChuckNorrisViperTests
//
//  Created by Dan Danilescu on 11/23/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import XCTest
@testable import ChuckNorrisViper

class JokeTests: XCTestCase {

    var testJoke: Joke!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        testJoke = Joke(json: ["value": "Test Joke: Chuck Norris can't be tested!"])
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        testJoke = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
