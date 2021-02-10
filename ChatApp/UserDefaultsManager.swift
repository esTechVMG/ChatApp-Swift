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

