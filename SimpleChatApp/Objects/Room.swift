//
//  Room.swift
//  SimpleChatApp
//
//  Created by yonekan on 2019/08/09.
//  Copyright © 2019 yonekan. All rights reserved.
//

// struct: 構造体
// チャットの部屋の情報を持つ構造体
struct Room {
    
    // 部屋の名前
    let name: String
    
    // 部屋のID（Firestoreで使用するキーを入れる）
    let documentId: String
}
