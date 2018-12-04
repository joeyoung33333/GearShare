//
//  GearViewController.swift
//  GearShare
//
//  Created by Joseph Young on 12/1/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class GearViewController: UIViewController {
    // outlets
    
    // actions
    var db = Firestore.firestore()
    
    
    var gearItems = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Query All Documents in Collection: get all firebase database reference
        db.collection("rental_items").getDocuments() { (querySnapshot, err) in
            print("All Documents")
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
        
        // Query all items where the field is equal to ...
        db.collection("rental_items").whereField("Product_Condition", isEqualTo: 8)
            .getDocuments() { (querySnapshot, err) in
                print("Query all documents with Rating Field == 5")
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }
        
        // Query One Specific Document: gets one specified document
        db.collection("rental_items").document("964ZrTnR3ot9iGHVFOgs").getDocument { (document, error) in
            print("One Specific Document")
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
        
    }

}
