//
//  User.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-02.
//

import Foundation

struct User {
    let name: String
    let username: String
    let id: String
    let adminUser: Bool
    
    init(name: String, username: String, id: String, adminUser: Bool) {
        self.name = name
        self.username = username
        self.id = id
        self.adminUser = adminUser
    }
}
