//
//  ChuckNorrisViperUITests.swift
//  ChuckNorrisViperUITests
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import XCTest

class ChuckNorrisViperUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test.
        // Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
        //- required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let randomJokeButton = app.buttons["Random Joke"]
        randomJokeButton.tap()
        XCUIApplication().children(matching: .window)
            .element(boundBy: 0).children(matching: .other)
            .element.children(matching: .textView).element.swipeUp()
        randomJokeButton.tap()
        XCUIApplication().children(matching: .window)
            .element(boundBy: 0).children(matching: .other)
            .element.children(matching: .textView).element.swipeUp()
        app.buttons["Categories"].tap()
        app.sheets["Categories"].buttons["food"].tap()

    }

}
