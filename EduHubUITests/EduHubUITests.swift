//
//  EduHubUITests.swift
//  EduHubUITests
//
//  Created by Thamindu Gamage on 2024-04-11.
//

import XCTest

final class EduHubUITests: XCTestCase {

    override func setUpWithError() throws {
           continueAfterFailure = false
           // Additional setup code can go here if needed
       }

       override func tearDownWithError() throws {
           // Additional teardown code can go here if needed
       }

    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()

        // Wait for the username text field to appear
        let usernameTextField = app.textFields["userName"]
        XCTAssertTrue(usernameTextField.waitForExistence(timeout: 10), "Username text field not found")

        // Enter valid username
        usernameTextField.tap()
        usernameTextField.typeText("valid@email.com")

        // Wait for the password text field to appear
        let passwordTextField = app.textFields["password"]
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10), "Password text field not found")

        // Enter valid password
        passwordTextField.tap()
        passwordTextField.typeText("validpassword")

        // Wait for the login button to appear
        let loginButton = app.buttons["loginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10), "Login button not found")

        // Tap the login button
        loginButton.tap()

        // Verify that the homeView is presented after successful login
        XCTAssertTrue(app.navigationBars["homeView"].waitForExistence(timeout: 10), "Failed to navigate to homeView after login")
    }
}
