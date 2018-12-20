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

// Edit Profile - This view controller allows the user to edit their profile data, which will be updated in the database as well as all the product entries belonging the that user will be reflect this change as well

class EditUserViewController: UIViewController {
    // outlet
    @IBOutlet weak var EditUserEmail: UITextField!
    @IBOutlet weak var EditUserName: UITextField!
    @IBOutlet weak var EditUserAddress: UITextField!
    
    var db = Firestore.firestore()
    var userID: String!
    var profileEntryRef: DocumentReference!
    
    // update user profiles
    @IBAction func EditUserDoneButton(_ sender: Any) {
        if !(self.EditUserName.text == "" || self.EditUserAddress.text == "") {
            
            let currUser = Auth.auth().currentUser
            let changeRequest = currUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.EditUserName.text
            changeRequest?.commitChanges { (error) in
                if error == nil {
                    // then try to update email
                    Auth.auth().currentUser?.updateEmail(to: String(self.EditUserEmail.text!)) { (error) in
                        if error == nil {
                            // update user profile entry
                            self.profileEntryRef = Firestore.firestore().document("users/\(currUser!.uid)")
                            print(self.profileEntryRef)
                            print("Address \(self.EditUserAddress.text!)")
                            self.profileEntryRef.updateData([
                                "address": self.EditUserAddress.text!
                            ]) { err in
                                if let err = err {
                                    // display corresponding message for error
                                    print("Error in updating entry \(err)")
                                } else {
                                    print("Update successful");
                                }
                            }
                            let user = Auth.auth().currentUser
                            if let user = user {
                                let userUID = user.uid
                                self.userID = user.uid
                                // find the current user in the db
                                
                                self.db.collection("items").whereField("owner_UID", isEqualTo: userUID)
                                    .getDocuments() { (querySnapshot, error) in
                                        if let error = error {
                                            // error trapping for not being able to get documents
                                            print("Error getting documents from authenticated user: \(error)")
                                            let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                                            // alert for the error
                                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                            alertController.addAction(defaultAction)
                                            // present the alert controller if there's an error
                                            self.present(alertController, animated: true, completion: nil)
                                        } else {
                                            for document in querySnapshot!.documents {
                                                var docData = document.data()
                                                let docRef = self.db.collection("items").document(docData["item_name"] as! String)
                                                docRef.updateData([
                                                    "address": self.EditUserAddress.text!
                                                ]) { error in
                                                    if let error = error {
                                                        print("Error in updating entry \(error)")
                                                        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                                                        
                                                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                                        alertController.addAction(defaultAction)
                                                        
                                                        self.present(alertController, animated: true, completion: nil)
                                                    } else {
                                                        print("Update item status successful")
                                                        let alertController = UIAlertController(title: "Success!", message: "You Requested an Item", preferredStyle: .alert)
                                                        
                                                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                                        alertController.addAction(defaultAction)
                                                        
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                                
                                            }
                                        }
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
                            
                        } else {
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
        } else {
            // alert user if inputs are invalid
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
        // Display data with pre-existing information from user
        if let user = user {
            self.EditUserEmail.text = user.email
            self.EditUserName.text = user.displayName
            let userProfileRef = Firestore.firestore().document("users/\(user.uid)");
            
            // pull user address from users db
            userProfileRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let userProfile = document.data()
                    let userAddress = userProfile?["address"] as? String ?? ""
                    print("Document data: \(userAddress)")
                    print(userAddress)
                    self.EditUserAddress.text = userAddress
                } else {
                    // show that user address has not been added
                    self.EditUserAddress.text = "Not added"
                    print("Document does not exist")
                }
            }
        } else {
            print("Not Logged In")
        }
    }
    
    
}
