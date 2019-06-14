//
//  CategoriesBuilder.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 10/11/2017.
//  Copyright © 2017 Endava. All rights reserved.
//

import UIKit
import Swinject

class CategoriesDefaultModuleBuilder: NSObject {

    fileprivate let container: Container

    init(parentContainer: Container) {
        container = Container(parent: parentContainer)
    }

    func build() -> CategoriesViewController! {

        container.register(CategoriesInteractor.self) { _ in
            CategoriesInteractorImp() //Add service
        }

        container.register(CategoriesViewController.self) { _ in

            CategoriesViewController(nibName: String(describing: CategoriesViewController.self), bundle: Bundle.main)

            }.initCompleted { container, view in

                view.presenter = container.resolve(CategoriesPresenter.self)
        }

        container.register(CategoriesRouter.self) { container in
            let router = CategoriesRouterImp()
            router.viewController = container.resolve(CategoriesViewController.self)!
            return router
        }

        container.register(CategoriesPresenter.self) { container in
            CategoriesPresenterImp(view: container.resolve(CategoriesViewController.self)!,
                                interactor: container.resolve(CategoriesInteractor.self)!,
                                router: container.resolve(CategoriesRouter.self)!)
        }

        return container.resolve(CategoriesViewController.self)!
    }
}
