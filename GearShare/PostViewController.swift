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

// Post - View Controller to allow users to post item listings to the database, including information regarding item name, price per day, item condition and current photo of items

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // User item information inputs
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var priceDay: UITextField!
    //@IBOutlet weak var itemCondition: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemConditionPicker: UIPickerView!

    var docRef: DocumentReference!
    
    //Retrieve information from current user's user profile from usersdb
    var user = Auth.auth().currentUser
    var userAddress: String!
    
    //Array for item condition values
    var itemConditionValueSelector: [String] = [String]()
    
    //Holds image from camera
    var imagePickerController: UIImagePickerController!
    
    //Initiates device camera, delegate to default camera controller
    @IBAction func takePhoto(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        // allow user to take a picture
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Sets image view to image taken from device
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print(itemConditionValueSelector.count)
        return itemConditionValueSelector.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemConditionValueSelector[row]
    }
    
    //Save image to Firebase storage
    func uploadImageToStorage(itemSlug: String, itemImage: UIImageView) {
        print("Uploading \(itemSlug) to Storage")
        //save image with unique slug
        let storageRef = Storage.storage().reference().child(itemSlug);
        if let imageUploadData = itemImage.image?.pngData() {
            storageRef.putData(imageUploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                } else {
                    print(metadata!)
                }
                
            })
        }
        
    }
    
    // on-click of post button, save entry to database
    @IBAction func postItem(_ sender: UIButton) {
        guard let itemNameEntry = itemName.text, !itemNameEntry.isEmpty else {return}
        guard let priceDayEntry = priceDay.text, !priceDayEntry.isEmpty else {return}

        //guard let itemConditionEntry = itemCondition.text, !itemConditionEntry.isEmpty else {return}
        let itemEntry: [String: Any] = ["owner_UID": user!.uid, "item_name": itemNameEntry, "price_per_day": priceDayEntry, "status": "available", "address": self.userAddress, "curr_renter_UID": "", "req_user_UID": "", "req_pick_up_date": "","req_return_date": "","item_condition": String(itemConditionPicker.selectedRow(inComponent: 0))]
        
        let userSlug = "\(user!.uid)-\(itemNameEntry)"
        print("USER SLUG: "+userSlug);
        docRef = Firestore.firestore().document("items/\(userSlug)")
        docRef.setData(itemEntry){ (error) in
            if error == nil {
                // upload image to firebase storage
                let itemImgSlug = "\(userSlug).png"
                self.uploadImageToStorage(itemSlug: itemImgSlug, itemImage: self.imageView)
                // alert user of successful post
                
                // reset fields
                self.itemName.text = ""
                self.priceDay.text = ""
                //self.itemCondition.text = ""
                self.imageView.image = UIImage(named: "blank_camera")
                
                // go to the home view controller if the post is sucessful
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
                // present error alert
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets default layout when view is loaded
        self.imageView.image = UIImage(named: "blank_camera")
        self.imageView.layer.borderColor = UIColor.gray.cgColor
        self.imageView.layer.borderWidth = 1.5
        
        // Connect data:
        self.itemConditionPicker.delegate = self
        self.itemConditionPicker.dataSource = self
        itemConditionValueSelector = ["1","2","3","4","5","6","7","8","9","10"]
        
        // Get initial data from logged in user
        let userProfileRef = Firestore.firestore().document("users/\(user!.uid)");
        userProfileRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userProfile = document.data()
                // retrieve user address
                self.userAddress = userProfile?["address"] as? String ?? ""
                print("Document data: \(self.userAddress!)")
                print(self.userAddress)
            } else {
                print("Document does not exist")
            }
        }
    }
}
