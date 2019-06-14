//
//  ServicesContainer.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/10/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import UIKit
import Swinject
import Alamofire

class ServicesContainer {

    static var `default`: Container = {
        let container = Container()
        container.register(JokesService.self, factory: { _ in
            JokesServiceImpl(baseUrl: "https://api.chucknorris.io",
                             manager: container.resolve(SessionManager.self)!)
        })

        container.register(SessionManager.self, factory: { _ in
            SessionManager.default
        })

        return container
    }()
}
