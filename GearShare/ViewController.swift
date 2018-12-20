//
//  ViewController.swift
//  GearShare
//
//  Created by Joe Young on 11/14/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit

// set up extension to remove keyboard
extension UIViewController {
    // all files calling this in the file will enable this feature
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        // enable tapping to exit the keyboard
        view.addGestureRecognizer(tap)
    }
    
    // actually dismisses the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {
    // HELLO
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

