//
//  Publication.swift
//  CComunities
//
//  Created by NICAELA on 27/8/16.
//  Copyright © 2016 QUIÑONES ALVAREZ ALAIN. All rights reserved.
//

import UIKit

class Publication{
    var title: String
    var description: UITextView?
    var responsable: String
    var date: String
    
    init?(title: String, description: UITextView?, responsable: String, date: String){
        self.title = title
        self.description = description
        self.responsable = responsable
        self.date = date
    
    }
}
