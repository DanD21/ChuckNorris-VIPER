//
//  ChuckNorrisViperApp.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI - VIPER Architecture
//

import SwiftUI

@main
struct ChuckNorrisViperApp: App {
    var body: some Scene {
        WindowGroup {
            HomeBuilder.build()
        }
    }
}
