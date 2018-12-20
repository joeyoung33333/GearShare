//
//  ResetPasswordViewController.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    // outlets
    @IBOutlet weak var ResetPasswordEmail: UITextField!
    
    // Reset Password action: method will reset password by sending email to user
    @IBAction func ResetPasswordButton(_ sender: Any) {
        if self.ResetPasswordEmail.text == "" {
            // alert user that they must enter an email address
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.ResetPasswordEmail.text!, completion: { (error) in
                // title represents success of the reset and message corresponds to the title
                var title = ""
                var message = ""
                
                // sets error or success messaage
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.ResetPasswordEmail.text = ""
                }
                
                // display error message as success or failed
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }
}
