//
//  Article.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-03.
//

import Foundation
import UIKit

struct Article {
    let title: String
    let image: URL?
    let description: String
    let authorName: String
    let category: String
    let special: Bool
    var user: String
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["title"] = title
        dictionary["description"] = description
        dictionary["image"] = image?.absoluteString
        dictionary["authorName"] = authorName
        dictionary["category"] = category
        dictionary["special"] = special
        dictionary["user"] = user
        return dictionary
    }
}
