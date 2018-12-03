//
//  UserViewController.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserViewController: UIViewController {
    // outlet
    @IBOutlet weak var UserProfileEmail: UILabel!
    @IBOutlet weak var UserProfileName: UILabel!
    @IBOutlet weak var UserProfileUID: UILabel!
    
    // action
    // Log Out: method allows user to log out
    @IBAction func LogOutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                // return to Login view controller
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
            
                // alert successful log out
                print("Sign out successful")
                let alertController = UIAlertController(title: "Success!", message: "You Have Logged Out", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                vc.present(alertController, animated: true, completion: nil)
                
            } catch let error as NSError {
                // print error to console
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func EditUserButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditUser")
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let user = Auth.auth().currentUser
        if let user = user {
            self.UserProfileEmail.text = user.email
            self.UserProfileUID.text = user.uid
            self.UserProfileName.text = user.displayName
        } else{
            print("Not Logged In")
        }
    }
    
    
}
