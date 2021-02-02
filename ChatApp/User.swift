//
//  User.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//

import Foundation
struct User : Codable{
    var name:String?
    var token:String
    init(name:String?,token:String) {
        self.name = name
        self.token = token
    }
}
struct UserList:Codable {
    var users:[User]
    init() {
        users=Array()
    }
}
