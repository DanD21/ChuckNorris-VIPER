//
//  HomePresenter.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation
import RxSwift

// Protocol that defines the commands sent from the View to the Presenter.
protocol HomePresenter: class {
    func viewDidLoad()
    func randomJokeRetrieved(joke: Joke)
    func failedToRetrieve()
    func randomButtonPressed()
    func categoriesButtonPressed()
    func categoriesRetrieved(categories: Category)
    func getJokeByCategory(category: String)
}

// Protocol that defines the commands sent from the Interactor to the Presenter.
class HomePresenterImpl: HomePresenter {

    // Reference to the View (weak to avoid retain cycle).
    weak var view: HomeView?

    // Reference to the Interactor's interface.
    var interactor: HomeInteractor!

    // Reference to the Router
    var router: HomeRouter!

    let disposeBag = DisposeBag()

    func randomButtonPressed() {
        interactor.getRandomJoke()
            .observeOn(MainScheduler.instance)
            .do(onNext: { (joke) in
                self.randomJokeRetrieved(joke: joke)
            }, onError: { (_) in
                self.failedToRetrieve()
            }).subscribe()
        .disposed(by: disposeBag)
    }

    func categoriesButtonPressed() {
//        router.

        interactor.getCategories()
            .observeOn(MainScheduler.instance)
            .do(onNext: { (json) in
                self.categoriesRetrieved(categories: json)

            }, onError: { (_) in
                self.failedToRetrieve()
            }).subscribe()
        .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        randomButtonPressed()
    }

    func randomJokeRetrieved(joke: Joke) {
        //guard let joke = joke.value else { return }
        view?.showJoke(joke: joke)
    }

    func categoriesRetrieved(categories: Category) {
        print("from presenter: \(categories)")
        view?.showCategories(categories: categories)
    }

    func getJokeByCategory(category: String) {
        interactor?.getJokeByCategory(category: category)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (joke) in
                self.randomJokeRetrieved(joke: joke)
            }, onError: { (_) in
                self.failedToRetrieve()
            }).subscribe()
        .disposed(by: disposeBag)
    }

    func failedToRetrieve() {
        view?.showError()
    }
}
