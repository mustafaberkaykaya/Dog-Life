//
//  UserSingleton.swift
//  DogLife
//
//  Created by Mustafa Berkay Kaya on 28.08.2020.
//  Copyright © 2020 Berkay Kaya. All rights reserved.
//

import Foundation
class UserSingleton {
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var nickname = ""
    var userPhoto = ""
    private init(){
        
    }
    
}
