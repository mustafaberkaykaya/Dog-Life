//
//  UploadViewController.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 26.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addDogIcone: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDogIcone.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goLibrary))
        addDogIcone.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        addDogIcone.isHidden = true
    }
    
    
    

    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("Media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                }else {
                   
                    imageReferance.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            let userData = ["email" : Auth.auth().currentUser?.email, "imageUrl":imageUrl,"date":FieldValue.serverTimestamp(),"comment":self.commentText.text!,"nickname":UserSingleton.sharedUserInfo.nickname,"userPhoto":UserSingleton.sharedUserInfo.userPhoto,"likes": 0 ] as [String:Any]
                            
                            // database islemleri
                            let db = Firestore.firestore()
                            var ref : DocumentReference? = nil
                            
                            ref = db.collection("Posts").addDocument(data: userData, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                                }else{
                                    self.tabBarController?.selectedIndex = 0
                                    self.imageView.image = UIImage(named: "Imageview.png")
                                    self.addDogIcone.isHidden = false
                                    self.commentText.text = ""
                                    print("succes")
                                    
                                }
                            })
                        }
                    }
                    
                }
            }
        }
    
    
    }
    @objc func goLibrary(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
      
    }
    func makeAlert(title:String,message:String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert,animated: true,completion: nil)
        }
   
}
