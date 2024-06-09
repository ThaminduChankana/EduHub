//
//  UserTest.swift
//  EduHubTests
//
//  Created by Thamindu Gamage on 2024-04-11.
//

import XCTest
@testable import EduHub

final class UserTest: XCTestCase {

    func testInitialization() {
            // Given
            let name = "John Doe"
            let username = "johndoe123"
            
            // When
            let user = User(name: name, username: username)
            
            // Then
            XCTAssertEqual(user.name, name)
            XCTAssertEqual(user.username, username)
        }

}
