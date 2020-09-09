//
//  SettingsViewController.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 26.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        do{
          try  Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("Error")
        }
                
    }
    
}
