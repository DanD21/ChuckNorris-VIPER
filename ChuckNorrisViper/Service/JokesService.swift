//
//  APIService.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol JokesService {
    func getRandomJoke() -> Observable<Joke>
    func getCategories() -> Observable<Category>
    func getJokeByCategory(category: String) -> Observable<Joke>
}

class JokesServiceImpl: JokesService {
    let baseUrl: String
    let manager: SessionManager

    init(baseUrl: String, manager: SessionManager) {
        self.baseUrl = baseUrl
        self.manager = manager
    }

    func getRandomJoke() -> Observable<Joke> {
        return manager.rx.json(.get, "\(baseUrl)/jokes/random")
            .map { json -> Joke in
                return Joke(json: json as! [String: Any])!
        }
    }

    func getCategories() -> Observable<Category> {
        return manager.rx.json(.get, "\(baseUrl)/jokes/categories")
            .map { json -> Category in
                return Category(json: json as! [String])!
        }
    }

    func getJokeByCategory(category: String) -> Observable<Joke> {
        return manager.rx.json(.get, "\(baseUrl)/jokes/random?category=\(category)")
            .map { json -> Joke in
                return Joke (json: json as! [String: Any])!
        }
    }
}
