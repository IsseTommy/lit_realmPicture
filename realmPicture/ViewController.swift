//
//  ViewController.swift
//  realmPicture
//
//  Created by Tommy on 2021/02/16.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    var realm: Realm!
    // Realmに保存されているPictureDataを格納する配列
    var pictures: Results<PictureData>!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // tableViewのdelegateとdatasourceの設定
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realmからデータを取得
        realm = try! Realm()
        pictures = realm.objects(PictureData.self)
        tableView.reloadData()
    }
    
    @IBAction func addImage() {
        // ボタンを押したときにカメラを起動
        let picker = UIImagePickerController()
        // ここを.photoLibraryに変えるとフォトライブラリから取得可能
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 撮影した写真を取得
        let image = info[.originalImage] as! UIImage
        // UIImageを0.9倍圧縮でNSDataに変換
        let data = NSData(data: image.jpegData(compressionQuality: 0.9)!)
        // RealmクラスのPictureDataを初期化
        let pictureData = PictureData()
        // pictureDataのdataに写真データが入ったNSDataを格納
        pictureData.data = data
        // タイトルを格納（本来はユーザーがテキストフィールドに入力した値を代入するのがベター）
        pictureData.title = "Test"
        // Realmに書き込み
        try! realm.write {
            realm.add(pictureData)
        }
        // Realmデータを更新し、テーブルビューに表示
        pictures = realm.objects(PictureData.self)
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    // TableView周りの処理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].title
        cell.imageView?.image = UIImage(data: pictures[indexPath.row].data as Data)
        return cell
    }
}
