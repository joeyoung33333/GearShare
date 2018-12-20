//
//  AppUITool.swift
//  final_project
//
//  Created by Joe Young on 10/11/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import Foundation
import UIKit

// create class for a rounded button component
class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1 / UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // make the radius of the button rounded
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(red: 74/225.0, green: 182/255.0, blue: 213/255.0, alpha: 1.0).cgColor
    }
}
