//
//  FeedViewController.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 28.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let  firestoreDatabase = Firestore.firestore()
    
    var commentArray = [String]()
    var dateArray = [String]()
    var emailArray = [String]()
    var imageUrlArray = [String]()
    var nickNameArray = [String]()
    var userPhotoArray = [String]()
    var documentIdArray = [String]()
    var likeArray = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getUserInfos()
        getDataFromFirestore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrlArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.bonesCounterLabel.text = String(likeArray[indexPath.row])
        cell.feedCommentLabel.text = commentArray[indexPath.row]
        cell.feedUserNameLabel.text = nickNameArray[indexPath.row]
        cell.feedImageView.sd_setImage(with: URL(string: self.imageUrlArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        cell.feedUserImage.sd_setImage(with: URL(string: userPhotoArray[indexPath.row]), completed: nil)
        cell.feedUserImage.layer.cornerRadius = cell.feedUserImage.frame.size.width / 2
        cell.feedUserImage.clipsToBounds = true
        return cell
    }
    func getUserInfos(){
        firestoreDatabase.collection("UserInfos").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
            }else {
                if snapshot?.isEmpty == false {
                    for document in snapshot!.documents{
                        if let nickname = document.get("nickname"){
                            if let userPhoto = document.get("userPhoto"){
                                UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                UserSingleton.sharedUserInfo.nickname =  nickname as! String
                                UserSingleton.sharedUserInfo.userPhoto = userPhoto as! String
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getDataFromFirestore(){
            
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
            }else {
                self.likeArray.removeAll(keepingCapacity: false)
                self.commentArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.emailArray.removeAll(keepingCapacity: false)
                self.imageUrlArray.removeAll(keepingCapacity: false)
                self.nickNameArray.removeAll(keepingCapacity: false)
                self.userPhotoArray.removeAll(keepingCapacity: false)
                self.documentIdArray.removeAll(keepingCapacity: false)
              
                for document in snapshot!.documents {
                    let documentId = document.documentID
                    self.documentIdArray.append(documentId)
                    
                    if let comment = document.get("comment") as? String {
                        self.commentArray.append(comment)
                    }
                    if let date = document.get("date") as? String {
                        self.dateArray.append(date)
                    }
                    if let email = document.get("email") as? String {
                        self.emailArray.append(email)
                    }
                    if let imageUrl = document.get("imageUrl") as? String {
                        self.imageUrlArray.append(imageUrl)
                    }
                    if let nickname = document.get("nickname") as? String {
                        self.nickNameArray.append(nickname)
                    }
                    if let userPhoto = document.get("userPhoto") as? String {
                        self.userPhotoArray.append(userPhoto)
                    }
                    if let likes = document.get("likes") as? Int {
                        self.likeArray.append(likes)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func dowlandImageTap(_ sender: Any) {
        self.makeAlert(title: "Succesful", message: "Image saved your gallery")
    }
    
    func makeAlert(title:String,message:String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(okButton)
           present(alert,animated: true,completion: nil)
       }
}

