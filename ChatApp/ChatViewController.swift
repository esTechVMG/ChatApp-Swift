//
//  ChatViewController.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//
import UIKit
class ChatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatMessageCell = tableView.dequeueReusableCell(withIdentifier: "ChatBubble", for: indexPath) as! ChatMessageCell
        return cell
    }
    
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
