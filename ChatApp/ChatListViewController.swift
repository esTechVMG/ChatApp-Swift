//
//  ChatListViewController.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//

import UIKit
class ChatListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    var userDefaultsManager:UserDefaultsManager = UserDefaultsManager()
    override func viewDidLoad() {
        //Create if not exists
        tableView.delegate = self
        tableView.dataSource = self
        let nc = NotificationCenter.default
        NotificationCenter.default.addObserver(self, selector: #selector(userReopenedApp), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.userDefaultsManager.getUserProfile()
        usernameLabel.text = userDefaultsManager.mainUser.name
    }
    @objc func userReopenedApp() -> Void {
        print("User has reopened the app!")
        userDefaultsManager.readChatListFromUserDefaults()
        tableView.reloadData()
    }
    var user:UserDefaultsManager = UserDefaultsManager()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController:ChatViewController = storyboard.instantiateViewController(identifier: "ChatView") as! ChatViewController
        viewController.user = userDefaultsManager.userList.users[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaultsManager.userList.users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatItem", for: indexPath) as! ChatListCell
        let user:User = userDefaultsManager.userList.users[indexPath.row]
        cell.id.text = user.token
        cell.username.text = user.name
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
    
    @IBAction func changeNamePressed(_ sender: Any) {
        alertWithPlaceholder(placeholder: "Insert new Username", handler: {(output:String)-> Void in
            self.userDefaultsManager.getUserProfile()
            self.userDefaultsManager.mainUser.name=output
            self.userDefaultsManager.storeUserProfile()
            self.usernameLabel.text = output
        })
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        alertWithPlaceholder(placeholder: "Insert Token", handler: {(output:String) -> Void in
            self.userDefaultsManager.userList.users.append(User(name: nil, token: output))
            self.tableView.reloadData()
            self.userDefaultsManager.storeToChatList()
        })
    }
    func alertWithPlaceholder(placeholder:String,handler:@escaping (_ output:String) -> Void) -> Void {
        let alertController = UIAlertController(title: placeholder, message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = placeholder
                }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { ( result : UIAlertAction) -> Void in
            print("Cancel")
                }
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            if let token:String = alertController.textFields?.first?.text{
                print(token)
                if token != ""{
                    handler(token)
                }else{
                    let alertController2 = UIAlertController(title: "Error", message: "No ha introducido nada", preferredStyle: .alert)
                    let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController2.addAction(okAlertAction)
                    self.present(alertController2, animated: true, completion: nil)
                }
            }else{
            }
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
