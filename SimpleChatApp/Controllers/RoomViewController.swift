//
//  RoomViewController.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/08/09.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    // どの部屋か特定するためのドキュメントIDを受け取る変数
    var documentId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func didClickButton(_ sender: UIButton) {
    }
    
    
}
