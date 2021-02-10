//
//  User.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//

import Foundation
func apnObjectToUserMessageObject(apn:ApnObject) -> UserMessage {
    return UserMessage(author: apn.username, message: apn.aps.alert.body)
}
func apnObjectToUserObject(apn:ApnObject)-> User {
    return User(name: apn.username, token: apn.token)
}

struct User : Codable{
    var name:String?
    var token:String
    init(name:String?,token:String) {
        self.name = name
        self.token = token
    }
}
class UserList:Codable {
    var users:[User]
    init() {
        users=Array()
    }
}
struct ApnObject:Codable {
    var aps:aps
    var username:String
    var token:String
}
struct aps:Codable{
    var alert:alert
    var sound:String
    var badge:Int
    var link_url:String
    var category:String
}
struct alert:Codable{
    var title:String
    var body:String
}
struct UserMessage:Codable {
    var author:String? = "UnknownUser"
    var message:String = "HelloWorld"
    var isMessageMine:Bool?
    init(author:String?, message:String) {
        self.author = author
        self.message = message
    }
}
struct  UserMessageList:Codable{
    var messageList:[UserMessage]
    init() {
        messageList=Array()
    }
}
/*
 APNS Message
 {
     "aps":{
         "alert": {
             "title": "Notificación recibida de la aplicacion push",
             "body": "Acepta el nuevo evento para mas informacion"
         },
         "sound": "default",
         "badge": 3,
         "link_url": "https://escuelaestech.es",
         "category": "TEST_PUSH"
     },
     "username": "Vicente"
     "token": "ej84uhfg58"
 }

 */
