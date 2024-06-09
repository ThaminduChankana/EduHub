//
//  ArticleCategoryTest.swift
//  EduHubTests
//
//  Created by Thamindu Gamage on 2024-04-11.
//

import XCTest
@testable import EduHub

final class ArticleCategoryTest: XCTestCase {

    func testInitialization() {
            // Given
            let id = "1"
            let name = "Technology"
            let imageUrl = URL(string: "https://example.com/image.jpg")
            
            // When
            let category = ArticleCategory(id: id, name: name, image: imageUrl)
            
            // Then
            XCTAssertEqual(category.id, id)
            XCTAssertEqual(category.name, name)
            XCTAssertEqual(category.image, imageUrl)
        }

}
