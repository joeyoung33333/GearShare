//
//  AppUITool.swift
//  final_project
//
//  Created by Joe Young on 10/11/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import Foundation
import UIKit


class RoundedButton: UIButton{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1/UIScreen.main.nativeScale
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = isEnabled ? tintColor.cgColor: UIColor.lightGray.cgColor
    }
}
