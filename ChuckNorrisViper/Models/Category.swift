//
//  Category.swift
//  ChuckNorrisViper
//
//  Swift 6 + SwiftUI Migration
//

import Foundation

typealias Categories = [String]

extension Array where Element == String {
    var asCategories: Categories {
        return self
    }
}
