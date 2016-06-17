//
//  TrophiesCell.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 6/17/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class TrophiesCell: UITableViewCell {

    @IBOutlet weak var imgLevel: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInformations(image: UIImage, description: String) {
        self.imgLevel.image =  image
        self.lblDescription.text = description
        
        self.imgLevel.layer.bounds = self.imgLevel.bounds
        self.imgLevel.layer.borderWidth = 10.0
        self.imgLevel.layer.masksToBounds = false
        self.imgLevel.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgLevel.layer.cornerRadius = self.imgLevel.frame.size.height/2
        
        self.imgLevel.clipsToBounds = true
    }
    
}
