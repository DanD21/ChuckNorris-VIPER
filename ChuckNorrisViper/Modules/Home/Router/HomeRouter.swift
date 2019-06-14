//
//  HomeRouter.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation

protocol HomeRouter {
    func showCategoriesTable()
}

class HomeRouterImpl: HomeRouter {

    weak var homeViewController: HomeViewImpl!

    func showCategoriesTable() {

        let categoriesBuilder = CategoriesDefaultModuleBuilder(parentContainer: ServicesContainer.default)
        let categoriesViewController = categoriesBuilder.build()

//        homeViewController.present(categoriesViewController, animated: true, completion: nil)
    }
}
