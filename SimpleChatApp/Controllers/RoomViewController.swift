//
//  RoomViewController.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/08/09.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    // どの部屋か特定するためのドキュメントIDを受け取る変数
    var documentId = ""
    
    // 選択された部屋で投稿されたメッセージを全件もつ配列
    var messages: [Message] = [] {
        // 変数messagesの値が変わった時に実行される
        didSet {
            // テーブルを更新
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // 送信ボタンがクリックされた時の処理
    @IBAction func didClickButton(_ sender: UIButton) {
        // 文字が空かどうかチェック
        if messageTextField.text!.isEmpty {
            // 空の場合は処理中断
            return
        }
        
        // 画面に入力されたテキストを変数に保存
        let message = messageTextField.text!
        
        // Firestoreに接続
        let db = Firestore.firestore()
        
        // メッセージをFirestoreに登録
        db.collection("room").document(documentId).collection("message").addDocument(data: [
            "text": message,
            "createdAt": FieldValue.serverTimestamp()
        ]) { error in
            
            if let err = error {
                print("メッセージの送信に失敗しました")
                print(err)
            } else {
                print("メッセージを送信しました")
            }
            
        }
        // メッセージの入力欄を空にする
        messageTextField.text = ""
    }
    
    
}


extension RoomViewController: UITableViewDataSource, UITableViewDelegate {
    
    // テーブルに表示するデータの件数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルの取得（セルの名前と、行番号から）
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 取得したセルにメッセージのテキストを設定
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        
        // できたセルを画面に返却
        return cell
    }
    
}
