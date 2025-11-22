//
//  MockHomeRouter.swift
//  ChuckNorrisViperTests
//
//  Mock router for testing HomePresenter
//

import Foundation
@testable import ChuckNorrisViper

@MainActor
class MockHomeRouter: HomeRouterProtocol {
    var navigateToCategoriesCalled = false

    func navigateToCategories() {
        navigateToCategoriesCalled = true
    }

    func reset() {
        navigateToCategoriesCalled = false
    }
}
