//
//  CategoriesViewController.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 10/11/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit

protocol CategoriesView: class {

}

class CategoriesViewController: UIViewController, CategoriesView {

    var presenter: CategoriesPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
