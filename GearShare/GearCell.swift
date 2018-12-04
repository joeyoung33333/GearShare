//
//  GearCell.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GearCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
