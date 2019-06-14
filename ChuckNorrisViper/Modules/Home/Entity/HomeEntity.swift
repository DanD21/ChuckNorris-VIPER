//
//  HomeEntity.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation

struct Joke {
    let value: String

init?(json: [String: Any]) {
    guard
        let value = json["value"] as? String
    else {
        return nil
    }
    self.value = value
    }
}
