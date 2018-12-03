//
//  SignUpViewController.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    // outlets
    @IBOutlet weak var SignUpEmail: UITextField!
    @IBOutlet weak var SignUpPassword: UITextField!
    
    // actions
    // Sign Up: method allows user to create an account with their email and password
    @IBAction func SignUpButton(_ sender: Any) {
        if SignUpEmail.text == "" {
            // alert user of error that nothing has been entered
            let alertController = UIAlertController(title: "Error!", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: SignUpEmail.text!, password: SignUpPassword.text!) { (user, error) in
                if error == nil {
                    // successful account creation
                    
                    // reset text fields
                    self.SignUpEmail.text = ""
                    self.SignUpPassword.text = ""
                    
                    // return to login view controller
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                    self.present(vc, animated: true, completion: nil)
                    
                    // alerts successful account creation
                    let alertController = UIAlertController(title: "Success!", message: "Your Account Has Been Created", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    vc.present(alertController, animated: true, completion: nil)
                } else {
                    // account creation failed, so alert user of errors from firebase
                    let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // FIX: Add dismis keyboard

    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
