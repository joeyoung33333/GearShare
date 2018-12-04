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
import FirebaseFirestore

class EditUserViewController: UIViewController {
    // outlet
    @IBOutlet weak var EditUserEmail: UITextField!
    @IBOutlet weak var EditUserName: UITextField!
    @IBOutlet weak var EditUserAddress: UITextField!
    
    var profileEntryRef: DocumentReference!
    
    // action
    @IBAction func EditUserDoneButton(_ sender: Any) {
        if !(self.EditUserName.text == "" || self.EditUserAddress.text == ""){
            let currUser = Auth.auth().currentUser
            let changeRequest = currUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.EditUserName.text
            changeRequest?.commitChanges { (error) in
                if error == nil {
                    // then try to update email
                    Auth.auth().currentUser?.updateEmail(to: String(self.EditUserEmail.text!)) { (error) in
                        if error == nil {
                            //Update user profile entry
                            self.profileEntryRef = Firestore.firestore().document("users/\(currUser!.uid)");
                            print(self.profileEntryRef)
                            print("Address \(self.EditUserAddress.text!)")
                            self.profileEntryRef.updateData([
                                "address": self.EditUserAddress.text!
                            ]) { err in
                                if let err = err {
                                    print("Error in updating entry \(err)")
                                } else {
                                    print("Update successful");
                                }
                            }
                            
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
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view, typically from a nib.
        let user = Auth.auth().currentUser
        if let user = user {
            self.EditUserEmail.text = user.email
            self.EditUserName.text = user.displayName
            //self.EditUserAddress.text = "Nothing Added"
            let userProfileRef = Firestore.firestore().document("users/\(user.uid)");
            //Pull user address from users db
            userProfileRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let userProfile = document.data()
                    let userAddress = userProfile?["address"] as? String ?? ""
                    print("Document data: \(userAddress)")
                    print(userAddress)
                    self.EditUserAddress.text = userAddress
                } else {
                    //Show that user address has not been added
                    self.EditUserAddress.text = "Not added"
                    print("Document does not exist")
                }
            }
        } else{
            print("Not Logged In")
        }
    }
    
    
}
