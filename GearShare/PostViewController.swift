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
    @IBOutlet weak var saveSuccess: UILabel!
    @IBOutlet weak var itemAddress: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    let demoUserId = "TestUser01"
    var docRef: DocumentReference!
    
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
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        //imageView.image = info[,]
    }

    
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
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
}
