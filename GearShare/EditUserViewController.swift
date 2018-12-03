//
//  EditUserViewController.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditUserViewController: UIViewController {
    // outlet
    @IBOutlet weak var EditUserEmail: UITextField!
    @IBOutlet weak var EditUserName: UITextField!
    @IBOutlet weak var EditUserAddress: UITextField!
    
    // action
    @IBAction func EditUserDoneButton(_ sender: Any) {
        if !(self.EditUserName.text == "" || self.EditUserAddress.text == ""){
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.EditUserName.text
            changeRequest?.commitChanges { (error) in
                if error == nil {
                    // then try to update email
                    Auth.auth().currentUser?.updateEmail(to: String(self.EditUserEmail.text!)) { (error) in
                        if error == nil {
                            // go to the home view controller if the login is sucessful
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                            self.present(vc, animated: true, completion: nil)
                            
                            // alert successful log in
                            print("You have successfully changed your account info")
                            let alertController = UIAlertController(title: "Success!", message: "You Have Changed Your Info", preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            vc.present(alertController, animated: true, completion: nil)
                            
                        }else{
                            // alert the user with the firebase error
                            let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    // alert the user with the firebase error
                    let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else{
            print("User did not enter an email or address")
            let alertController = UIAlertController(title: "Error!", message: "Please enter a name or address", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let user = Auth.auth().currentUser
        if let user = user {
            self.EditUserEmail.text = user.email
            self.EditUserName.text = user.displayName
            self.EditUserAddress.text = "Nothing Added"
        } else{
            print("Not Logged In")
        }
    }
    
    
}
