//
//  ChatViewController.swift
//  ChatApp
//
//  Created by A4-iMAC01 on 02/02/2021.
//
import UIKit
class ChatViewController : UIViewController, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self;
    }
}
