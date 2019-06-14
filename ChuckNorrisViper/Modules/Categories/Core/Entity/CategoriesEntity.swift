//
//  CategoriesEntity.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/13/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation

struct Category {
    var categories = [String]()

    init?(json: [String]) {
        for category in json {
            categories.append(category)
        }
//        self.categories = json
    }
}
