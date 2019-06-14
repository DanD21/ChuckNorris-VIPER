//
//  Builder.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import Foundation
import Swinject

class HomeBuilder {

    let container = Container(parent: ServicesContainer.default)

    func getRootModuleView() -> UIViewController {

        self.container.register(HomeView.self) { _ in
            HomeViewImpl(nibName: "HomeView", bundle: Bundle.main)

            }.initCompleted { _, view in
                if let viewController = view as? HomeViewImpl {
                    viewController.presenter = self.container.resolve(HomePresenter.self)
                }
            }

        self.container.register(HomePresenter.self) { _ in
            HomePresenterImpl()
            } .initCompleted { _, presenter in
                if let presenter = presenter as? HomePresenterImpl {
                    presenter.view = self.container.resolve(HomeView.self)
                    presenter.interactor = self.container.resolve(HomeInteractor.self)
                    presenter.router = self.container.resolve(HomeRouter.self)
                }
            }

        self.container.register(HomeInteractor.self) { _ in
            HomeInteractorImpl()
            }.initCompleted { _, view in
                if let interactor = view as? HomeInteractorImpl {
                    interactor.presenter = self.container.resolve(HomePresenter.self)
                    interactor.jokesService = self.container.resolve(JokesService.self)
                }
        }

        self.container.register(HomeRouter.self) { _ in
            HomeRouterImpl()
//            let router = HomeRouterImpl()
//            router.viewController = container.resolve(CategoriesViewController.self)!
//            return router
        }
        guard let viewController = self.container.resolve(HomeView.self) as? UIViewController
            else { return UIViewController() }
        return viewController
    }

    deinit {
        self.container.removeAll()
    }
}
