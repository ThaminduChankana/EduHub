//
//  ArticleTest.swift
//  EduHubTests
//
//  Created by Thamindu Gamage on 2024-04-11.
//

import XCTest
@testable import EduHub

final class ArticleTest: XCTestCase {
    func testToDictionary() {
         // Given
         let article = Article(title: "Test Article", image: URL(string: "https://example.com/image.jpg"), description: "This is a test article", authorName: "Test Author", category: "Test Category", special: true)
 
         // When
         let dictionary = article.toDictionary()
 
         // Then
         XCTAssertEqual(dictionary["title"] as? String, "Test Article")
         XCTAssertEqual(dictionary["description"] as? String, "This is a test article")
         XCTAssertEqual(dictionary["authorName"] as? String, "Test Author")
         XCTAssertEqual(dictionary["category"] as? String, "Test Category")
         XCTAssertEqual(dictionary["special"] as? Bool, true)
         XCTAssertEqual(dictionary["image"] as? String, "https://example.com/image.jpg")
     }

}
