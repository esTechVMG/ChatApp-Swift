//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//

import UIKit
class ChatListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var userList:UserList=UserList()
    var defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    func storeToChatList(user:UserList) {
        do {
            let data = try encoder.encode(user)
            // Write/Set Data
            defaults.set(data, forKey: "ChatList")
            
        } catch {
            print("Unable to Encode (\(error))")
            
        }
    }
    func readFromUserDefaults() -> Bool {
        do {
            let data = defaults.data(forKey: "ChatList")
            let newDefaults:UserList = try decoder.decode(UserList.self, from: data ?? Data())
            userList = newDefaults
            return true
        } catch {
            print("Unable to Decode (\(error))")
            return false
        }
    }
    
    override func viewDidLoad() {
        //Create if not exists
        tableView.delegate = self
        tableView.dataSource = self
        readFromUserDefaults()
        
        //userList.users.append(User(name: "Vicente", token: "fmgthgio5unbgiu58hgt"))
        //userList.users.append(User(name: "Alberto", token: "ru4ohut549ij5it959iut"))
        //userList.users.append(User(name: "Juan", token: "45j0fi6otj6imugou6ng059"))
        //storeToChatList(user: userList)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatItem", for: indexPath) as! ChatListCell
        let user:User = userList.users[indexPath.row]
        cell.id.text = user.token
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}