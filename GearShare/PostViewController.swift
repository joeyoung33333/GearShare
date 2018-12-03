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
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
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
            if error == nil {
                // alert user of successful post
                
                self.itemName.text = ""
                self.priceDay.text = ""
                self.itemAddress.text = ""
                
                let alertController = UIAlertController(title: "Success!", message: "Your Post was Published", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                // account creation failed, so alert user of errors from firebase
                let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                self.imageView.image = nil
                let borderColor = UIColor.blue
                self.imageView.layer.borderColor = borderColor.cgColor
                self.imageView.layer.borderWidth = 2.0
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
