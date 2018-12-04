//
//  PostViewController.swift
//  GearShare
//
//  Created by Aman Cheung on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // User item information inputs
    //@IBOutlet weak var userName: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var priceDay: UITextField!
    @IBOutlet weak var itemCondition: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    //let demoUserId = "TestUser01"
    var docRef: DocumentReference!
    
    //Retrieve information from current user's user profile from usersdb
    var user = Auth.auth().currentUser
    var userAddress: String!
    
    var imagePickerController: UIImagePickerController!
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }

    
    // On-click save entry
    @IBAction func postItem(_ sender: UIButton) {
        
        //guard let userNameEntry = userName.text, !userNameEntry.isEmpty else {return}
        guard let itemNameEntry = itemName.text, !itemNameEntry.isEmpty else {return}
        guard let priceDayEntry = priceDay.text, !priceDayEntry.isEmpty else {return}
        guard let itemConditionEntry = itemCondition.text, !itemConditionEntry.isEmpty else {return}
        let itemEntry: [String: Any] = ["owner_UID": user!.uid, "item_name": itemNameEntry, "price_per_day": priceDayEntry, "status": "available", "address": self.userAddress, "curr_renter_UID": "", "req_user_UID": "","item_condition": itemConditionEntry, "status": "available"]
        let userSlug = "\(user!.uid)-\(itemNameEntry)"
        print("USER SLUG: "+userSlug);
        docRef = Firestore.firestore().document("items/\(userSlug)")
        docRef.setData(itemEntry){ (error) in
            if error == nil {
                // alert user of successful post
                
                self.itemName.text = ""
                self.priceDay.text = ""
                self.itemCondition.text = ""
                
                self.imageView.image = UIImage(named: "blank_camera")
                
                // go to the home view controller if the login is sucessful
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                self.present(vc, animated: true, completion: nil)

                let alertController = UIAlertController(title: "Success!", message: "Your Post was Published", preferredStyle: .alert)
                
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view, typically from a nib.
        self.imageView.image = UIImage(named: "blank_camera")
        self.imageView.layer.borderColor = UIColor.gray.cgColor
        self.imageView.layer.borderWidth = 1.5
        //docRef = Firestore.firestore().document("items/itemEntry");
       
        /*
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
        */
        let userProfileRef = Firestore.firestore().document("users/\(user!.uid)");
        //print(userProfileRef)
        userProfileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userProfile = document.data()
                self.userAddress = userProfile?["address"] as? String ?? ""
                print("Document data: \(self.userAddress!)")
                print(self.userAddress)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
}
