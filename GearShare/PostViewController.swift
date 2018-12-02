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

class PostViewController: UIViewController {
    // User item information inputs
    //@IBOutlet weak var userName: UITextField!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var priceDay: UITextField!
    @IBOutlet weak var saveSuccess: UILabel!
    @IBOutlet weak var itemAddress: UITextField!
    
    let demoUserId = "TestUser01"
    var docRef: DocumentReference!
    
    // On-click save entry
    @IBAction func postItem(_ sender: UIButton) {
        
        //guard let userNameEntry = userName.text, !userNameEntry.isEmpty else {return}
        guard let itemNameEntry = itemName.text, !itemNameEntry.isEmpty else {return}
        guard let priceDayEntry = priceDay.text, !priceDayEntry.isEmpty else {return}
        guard let itemAddressEntry = itemAddress.text, !itemAddressEntry.isEmpty else {return}
        let itemEntry: [String: Any] = ["userID": self.demoUserId, "item": itemNameEntry, "pricePerDay": priceDayEntry, "requested": "false", "address": itemAddressEntry]
        let userSlug = "\(demoUserId)-\(itemNameEntry)"
        print("USER SLUG: "+userSlug);
        docRef = Firestore.firestore().document("items/\(userSlug)")
        docRef.setData(itemEntry){ (error) in
            if let error = error {
                print("Item entry SAVE ERROR \(error.localizedDescription)")
            } else {
                print("Item saved");
                self.saveSuccess.text = "Item is saved"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //docRef = Firestore.firestore().document("items/itemEntry");
    }
    
    
}
