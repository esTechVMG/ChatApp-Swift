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
    let devUrl:String = "http://localhost/APNS/"
    let baseUrl:String = "https://test5.qastusoft.com.es/Vicente/APNS/"
    var user:User = User(name: "Unknown User", token: "jit6yji77noyhu6t")
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var userDefaultsManager = UserDefaultsManager()
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        if ((user.name?.isEmpty) != nil){
            userNameLabel.text = user.name
        }else{
            userNameLabel.text = user.token
        }
        
        tableView.reloadData()
        userDefaultsManager.readChatFromUserDefaults(user: user)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let index = IndexPath(row: userDefaultsManager.messageList.messageList.count-1, section:0)
        if(index.row>=0){
            tableView.scrollToRow(at: index, at: .bottom, animated: false)
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if sendTextField.text != ""{
            var message = UserMessage(author: "Me", message: sendTextField.text!)
            message.isMessageMine = true
            addMessage(message: message)
            sendMessageToServer(userToSend: user, message: message)
        }
        sendTextField.text=""
        
    }
    
    
    func addMessage(message:UserMessage) {
        userDefaultsManager.messageList.messageList.append(message)
        tableView.reloadData()
        let index = IndexPath(row: userDefaultsManager.messageList.messageList.count-1, section:0)
        tableView.scrollToRow(at: index, at: .bottom, animated: true)
        userDefaultsManager.storeChatMessages(user: user)
        
    }
    func sendMessageToServer(userToSend:User, message:UserMessage) -> Void {
        let bodyData = "message=\(message.message)&username=\(user.name ?? "UnknownUser")&token=\(userToSend.token)"
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
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let data = data {
                print(String.init(data: data, encoding: .utf8) as Any)
            }
        }.resume()
    }
    
    
    
    //TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaultsManager.messageList.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = userDefaultsManager.messageList.messageList[indexPath.row]
        let cellId:String = message.isMessageMine ?? false ? "ChatBubbleMe" : "ChatBubbleOther"
        let cell:ChatMessageCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.messageLabel.text = message.message
        cell.authorLabel.text = message.author
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {return 1}
}
