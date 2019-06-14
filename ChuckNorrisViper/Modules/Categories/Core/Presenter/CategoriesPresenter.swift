//
//  CategoriesPresenter.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 10/11/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import Foundation

protocol CategoriesPresenter {
}

class CategoriesPresenterImp: CategoriesPresenter {

    weak var view: CategoriesView!
    var interactor: CategoriesInteractor!
    var router: CategoriesRouter!

    init(view: CategoriesView, interactor: CategoriesInteractor, router: CategoriesRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
