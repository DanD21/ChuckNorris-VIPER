//
//  HomeInteractor.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol HomeInteractor {
    func getRandomJoke() -> Observable<Joke>
    func getCategories() -> Observable<Category>
    func getJokeByCategory(category: String) -> Observable<Joke>
}

// The Interactor responsible for implementing the business logic of the module.
class HomeInteractorImpl: HomeInteractor {

    var presenter: HomePresenter!
    var jokesService: JokesService!

    func getRandomJoke() -> Observable<Joke> {
        return jokesService.getRandomJoke()
    }

    func getCategories() -> Observable<Category> {
        return jokesService.getCategories()
    }

    func getJokeByCategory(category: String) -> Observable<Joke> {
        return jokesService.getJokeByCategory(category: category)
    }
}
