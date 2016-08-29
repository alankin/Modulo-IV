//
//  User.swift
//  CComunities
//
//  Created by NICAELA on 28/8/16.
//  Copyright © 2016 QUIÑONES ALVAREZ ALAIN. All rights reserved.
//

import UIKit

class User{
    var userId: Int
    var name: String
    var lastName: String
    var email: String
    var photo: UIImage
    
    init?(userId: Int, name: String, lastName: String, email: String, photo: UIImage){
        self.userId = userId
        self.name = name
        self.lastName = lastName
        self.email = email
        self.photo = photo
        
    }
}
