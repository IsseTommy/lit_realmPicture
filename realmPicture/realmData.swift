//
//  realmData.swift
//  realmPicture
//
//  Created by Tommy on 2021/02/16.
//

import Foundation
import RealmSwift

class PictureData: Object {
    // 写真を格納するためのNSDataの変数
    @objc dynamic var data: NSData!
    // 写真の説明を格納するためのString型の変数
    @objc dynamic var title: String = ""
}
