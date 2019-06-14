//
//  AppDelegate.swift
//  ChuckNorrisViper
//
//  Created by Dan Danilescu on 11/9/17.
//  Copyright © 2017 Dan Danilescu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let builder = HomeBuilder()

//        let navigationController = UINavigationController(rootViewController: builder.getRootModuleView())
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = builder.getRootModuleView()
        self.window?.makeKeyAndVisible()

        return true
    }
}
