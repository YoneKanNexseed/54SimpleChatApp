//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/08/08.
//  Copyright © 2019 yonekan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var roomNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    // チャットの部屋一覧を保持する配列
    var rooms: [Room] = [] {
        // roomsが書き換わった時
        didSet {
            // テーブルを更新する
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Firestoreへ接続
        let db = Firestore.firestore()
        
        // コレクションroomが変更されたか検知するリスナーを登録
        db.collection("room").addSnapshotListener { (querySnapshot, error) in
            
            // querySnapshot.documents: room内の全件を取得
            guard let documents = querySnapshot?.documents else {
                // roomの中に何もない場合、処理を中断
                return
            }
            
            // 変数documentsにroomの全データがあるので、
            // それを元に配列を作成し、画面を更新する
            var results: [Room] = []
            
            for document in documents {
                let roomName = document.get("name") as! String
                let room = Room(name: roomName, documentId: document.documentID)
                
                results.append(room)
            }
            
            // 変数roomsを書き換える
            self.rooms = results
        }
    }

    // ルーム作成のボタンがクリックされた時
    @IBAction func didClickButton(_ sender: UIButton) {
        if roomNameTextField.text!.isEmpty {
            // テキストフィールドが空文字の場合
            // 処理中断
            return
        }
        
        // 部屋の名前を変数に保存
        let roomName = roomNameTextField.text!
        
        // Firestoreの接続情報取得
        let db = Firestore.firestore()
        
        // Firestoreに新しい部屋を追加
        db.collection("room").addDocument(data: [
            "name": roomName,
            "createdAt": FieldValue.serverTimestamp()   // 登録日時
        ]) { err in
            
            if let err = err {
                print("チャットルームの作成に失敗しました")
                print(err)
            } else {
                print("チャットルームを作成しました：\(roomName)")
            }
        }
        
        roomNameTextField.text = ""
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        // 右矢印設定
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    // didSelectRowAt: セルがクリックされた時に実行される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let room = rooms[indexPath.row]
        performSegue(withIdentifier: "toRoom", sender: room.documentId)
        
    }
    
}
