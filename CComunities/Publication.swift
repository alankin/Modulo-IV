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
    var description: String
    var responsable: String
    var date: String
    
    init?(title: String, description: String, responsable: String, date: String){
        self.title = title
        self.description = description
        self.responsable = responsable
        self.date = date
    
    }
}
