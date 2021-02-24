//
//  UserDefaultsManager.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 10/02/2021.
//

import Foundation
class UserDefaultsManager{
    var userList:UserList=UserList()
    var defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    func readChatListFromUserDefaults() {
        do {
            let data = defaults.data(forKey: "ChatList")
            let newDefaults:UserList = try decoder.decode(UserList.self, from: data ?? Data())
                userList = newDefaults;
        } catch {
            print("Unable to Decode (\(error))")
        }
    }
    func storeToChatList() {
        do {
            let data = try encoder.encode(userList)
            // Write/Set Data
            defaults.set(data, forKey: "ChatList")
        } catch {
            print("Unable to Encode (\(error))")
            
        }
    }
    var mainUser:User = User(name: "Anonymous User", token: "3a840fd4a7ea804719c17266e036f2e9879d2b704addbd84eec8ddefc9d6e44d")
    func getUserProfile() -> Void {
        do {
            let data = defaults.data(forKey: "UserProfile")
            let newDefaults:User = try decoder.decode(User.self, from: data ?? Data())
            mainUser = newDefaults
        } catch {
            print("Unable to Decode (\(error))")
            
        }
    }
    func storeUserProfile() -> Void {
        do {
            let data = try encoder.encode(mainUser)
            // Write/Set Data
            defaults.set(data, forKey: "UserProfile")
        } catch {
            print("Unable to Encode (\(error))")
            
        }
    }
    var messageList:UserMessageList=UserMessageList()
    func storeChatMessages(user:User) {
        do {
            let data = try encoder.encode(messageList)
            // Write/Set Data
            defaults.set(data, forKey: user.token)
            
        } catch {
            print("Unable to Encode (\(error))")
            
        }
    }
    func readChatFromUserDefaults(user:User) {
        do {
            let data = defaults.data(forKey: user.token)
            let newDefaults:UserMessageList = try decoder.decode(UserMessageList.self, from: data ?? Data())
            messageList = newDefaults
        } catch {
            print("Unable to Decode (\(error))")
        }
    }
}

