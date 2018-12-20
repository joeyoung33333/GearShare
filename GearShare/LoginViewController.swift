//
//  LoginViewController.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    // outlets
    @IBOutlet weak var LoginEmail: UITextField!
    @IBOutlet weak var LoginPassword: UITextField!
    
    // Login action: method allows user to submit request to login
    @IBAction func LoginButton(_ sender: Any) {
        if self.LoginEmail.text == "" || self.LoginPassword.text == "" {
            // checks for empty text fields and alerts of an error
            print("User did not enter an email or password")
            let alertController = UIAlertController(title: "Error!", message: "Please enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.LoginEmail.text!, password: self.LoginPassword.text!) { (user, error) in
                if error == nil {
                    // go to the home view controller if the login is sucessful
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                    self.present(vc, animated: true, completion: nil)
                    
                    // alert successful log in
                    print("You have successfully logged in")
                    let alertController = UIAlertController(title: "Success!", message: "You Have Logged In", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    vc.present(alertController, animated: true, completion: nil)
                    
                } else {
                    // alert the user with the firebase error
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
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }
}
