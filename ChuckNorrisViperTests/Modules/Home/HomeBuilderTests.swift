//
//  HomeBuilderTests.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 23/11/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import XCTest
import Swinject
@testable import ChuckNorrisViper

class HomeModuleBuilderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigureModuleForViewController() {
        let builder = HomeBuilder()
        let viewController = builder.getRootModuleView()

        XCTAssertNotNil(viewController, "HomeViewController is nil after configuration")
    }
}
