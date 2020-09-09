//
//  forgotPasswordViewController.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 24.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase
class forgotPasswordViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailText.text!) { (error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
            }else{
                self.makeAlert(title: "Succesful", message: "A password reset e-mail has been sent!")
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
