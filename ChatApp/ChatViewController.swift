//
//  ChatViewController.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//
import UIKit
class ChatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    func testingBlock() -> Void {
        for _ in 0...1{
            addMessage(message: UserMessage(author: "OtherPerson", message: "Hello"))
        }
    }
    
    var messageList:UserMessageList = UserMessageList()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        tableView.delegate = self
        tableView.dataSource = self
        
        getMessages()
    }
    override func viewWillAppear(_ animated: Bool) {
        testingBlock()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if sendTextField.text != ""{
            var message = UserMessage(author: "Me", message: sendTextField.text!)
            message.isMessageMine = true
            addMessage(message: message)
        }
        sendTextField.text=""
        
    }
    func addMessage(message:UserMessage) {
        messageList.messageList.append(message)
        tableView.reloadData()
        //Call for storing in UserDefaultsHere
    }
    func getMessages() -> Void {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageList.messageList[indexPath.row]
        let cellId:String = message.isMessageMine ?? false ? "ChatBubbleMe" : "ChatBubbleOther"
        let cell:ChatMessageCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.messageLabel.text = message.message
        cell.authorLabel.text = message.author
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
}
