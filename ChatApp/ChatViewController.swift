//
//  ChatViewController.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//
import UIKit
class ChatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    func testingBlock() -> Void {
        for _ in 0...10{
            addMessage(message: UserMessage(author: "OtherPerson", message: "Hello"))
        }
    }
    var userToken:String = "abcdefghijklmn"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var defaults = UserDefaults.standard
    func storeChatMessages(messageList:UserMessageList) {
        do {
            let data = try encoder.encode(messageList)
            // Write/Set Data
            defaults.set(data, forKey: userToken)
            
        } catch {
            print("Unable to Encode (\(error))")
            
        }
    }
    
    func readFromUserDefaults() {
        do {
            let data = defaults.data(forKey: userToken)
            let newDefaults:UserMessageList = try decoder.decode(UserMessageList.self, from: data ?? Data())
            messageList = newDefaults
        } catch {
            print("Unable to Decode (\(error))")
        }
    }
    
    
    var messageList:UserMessageList = UserMessageList()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        readFromUserDefaults()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let index = IndexPath(row: messageList.messageList.count-1, section:0)
        if(index.row>=0){
            tableView.scrollToRow(at: index, at: .bottom, animated: false)
        }
        
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
        let index = IndexPath(row: messageList.messageList.count-1, section:0)
        tableView.scrollToRow(at: index, at: .bottom, animated: true)
        //Call for storing in UserDefaultsHere
        storeChatMessages(messageList: messageList)
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
