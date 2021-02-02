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
struct UserMessage {
    var author:String = "No Author"
    var message:String = "Hello World"
    var isMessageMine:Bool = true
}
struct  UserMessageList{
    var messageList:[UserMessage]
}

