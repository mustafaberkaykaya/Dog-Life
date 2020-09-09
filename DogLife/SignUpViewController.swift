//
//  SignUpViewController.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 24.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var addButtonImage: UIImageView!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var miniDogImage: UIImageView!
    @IBOutlet weak var nicknameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtonImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToLibrary))
        addButtonImage.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func goToLibrary () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dogImage.image = info[.originalImage] as? UIImage
        dogImage.layer.cornerRadius = dogImage.frame.size.width / 2
        dogImage.clipsToBounds = true
        addButtonImage.isHidden = true
        miniDogImage.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            if passwordText.text == confirmPassword.text {
                //signUp Staff
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                    if error != nil {
                        self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                    }else{
                          let db = Firestore.firestore()
                        var ref: DocumentReference? = nil
                        
                        let storage = Storage.storage()
                        let storageReferance = storage.reference()
                        let usersPhoto = storageReferance.child("usersPhoto")
                        
                        if let data = self.dogImage.image?.jpegData(compressionQuality: 0.5){
                            let uuid = UUID().uuidString
                            let userImage = usersPhoto.child("\(uuid).jpg")
                            userImage.putData(data, metadata: nil) { (metadata, error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                                }else {
                                    userImage.downloadURL { (url, error) in
                                        if error == nil {
                                            let url = url?.absoluteString
                                            let userDictionary = ["email":self.emailText.text!,"nickname":self.nicknameText.text!,"userPhoto":url] as [String:Any]
                                            
                                            ref = db.collection("UserInfos").addDocument(data: userDictionary, completion: { (error) in
                                                if error != nil {
                                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                                                }else{
                                                    self.registerButtonOutlet.isHidden = true
                                                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                makeAlert(title: "Error", message: "Passwords are not matching")
            }
        }
    }
   func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert,animated: true,completion: nil)
    }
}
