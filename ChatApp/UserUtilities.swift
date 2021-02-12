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
             "title": "Notification title",
             "body": "Lorem ipsum dolor sit amet"
         },
         "sound": "default",
         "category": "ESTECHVMG_CHAT"
     },
     "username": "Vicente"
     "token": "ej84uhfg58"
 }

 */
//NOTE: The PHP Script is included in the root of the repository
let devUrl:String = "http://localhost/APNS/"
let baseUrl:String = "https://test5.qastusoft.com.es/Vicente/APNS/"
func sendMessageToServer(userToSend:User, message:UserMessage) -> Void {
    let bodyData = "message=\(message.message)&username=\(userToSend.name ?? "UnknownUser")&token=\(userToSend.token)"
    let Url = String(format: devUrl)
    print(userToSend)
    print(message)
    guard let serviceUrl = URL(string: Url) else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
    //print(bodyData)
    request.httpBody = bodyData.data(using: String.Encoding.utf8);
    //request.httpBody = httpBody
    URLSession.shared.dataTask(with: request) {(data, response, error) in
        if let data = data {
            print(String.init(data: data, encoding: .utf8) as Any)
        }
    }.resume()
}
