//
//  ViewController.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 24.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let token = AccessToken.current,
            !token.isExpired {
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    @IBAction func registerButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)

    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
            }else{
                //database
                self.performSegue(withIdentifier: "firstToTabBar", sender: nil)
            }
        }
    }
    
    func makeAlert(title:String,message:String){
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(okButton)
           present(alert,animated: true,completion: nil)
       }
    
       
    @IBAction func loginWithFacebookClicked(_ sender: Any) {
       let loginManager = LoginManager()
              loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                  if let error = error {
                      print("Failed to login: \(error.localizedDescription)")
                      return
                  }
                  
                  guard let accessToken = AccessToken.current else {
                      print("Failed to get access token")
                      return
                  }
       
                  let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                  
                  // Perform login by calling Firebase APIs
                  Auth.auth().signIn(with: credential, completion: { (user, error) in
                      if let error = error {
                          print("Login error: \(error.localizedDescription)")
                          let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                          let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                          alertController.addAction(okayAction)
                          self.present(alertController, animated: true, completion: nil)
                          return
                      }else {
                        self.performSegue(withIdentifier: "firstToTabBar", sender: nil)
                          self.currentUserName()
                      }
                  })
       
              }
    }
    func currentUserName()  {
        if let currentUser = Auth.auth().currentUser {
        }
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}

