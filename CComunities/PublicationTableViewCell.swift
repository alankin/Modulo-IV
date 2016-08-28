//
//  PublicationTableViewCell.swift
//  CComunities
//
//  Created by NICAELA on 27/8/16.
//  Copyright © 2016 QUIÑONES ALVAREZ ALAIN. All rights reserved.
//

import UIKit

class PublicationTableViewCell: UITableViewCell {

    @IBOutlet weak var responsableLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var photoUserImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
