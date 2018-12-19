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
import FirebaseUI

class GearViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gearTable: UITableView!
    var db = Firestore.firestore()
    
    // test cases
    var gearItems = [String]()
    var gearPrices = [String]()
    var gearCondition = [String]()
    var gearStatus = [String]()
    var userID: String!
    
    var productImages: [String: UIImage] = [:]

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gearItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("error here1")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GearCell
        
        // Code for loading image with SDWebImage
        let placeholderImage = UIImage(named: gearItems[indexPath.row])

        // Code for loading image with SDWebImage
        let storageRef = Storage.storage().reference()
        let imageSlug = "\(userID!)-\(gearItems[indexPath.row])"
        let reference = storageRef.child("\(imageSlug).png")
        reference.downloadURL { url, error in
            if let error = error {
                print(error)
                cell.productImage.image = UIImage(named: self.gearItems[indexPath.row])
            } else {
                cell.productImage.sd_setImage(with: url, placeholderImage: placeholderImage, completed: { (image, error, type, url) in
                    if let error=error {
                        print (error)
                    } else {
                        //cell.productImage.image?.imageOrientation
                        self.productImages[imageSlug] = image
                        print ("Image loaded")
                    }
                })
            }
            
        }
        
        //cell.productImage.image = UIImage(named: gearItems[indexPath.row])
        cell.productName.text = gearItems[indexPath.row]
        cell.productPrice.text = gearPrices[indexPath.row]
        if(gearStatus[indexPath.row] == "available"){
            cell.productStatus.text = gearStatus[indexPath.row]
            cell.productStatus.textColor = UIColor.green
            cell.productStatus.shadowColor = UIColor.gray
            cell.productStatus.shadowOffset = CGSize(width: 0.5, height: 0.5)
        } else if(gearStatus[indexPath.row] == "requested"){
            cell.productStatus.text = gearStatus[indexPath.row]
            cell.productStatus.textColor = UIColor.yellow
            cell.productStatus.shadowColor = UIColor.gray
            cell.productStatus.shadowOffset = CGSize(width: 0.5, height: 0.5)
        } else{
            cell.productStatus.text = gearStatus[indexPath.row]
            cell.productStatus.textColor = UIColor.red
            cell.productStatus.shadowColor = UIColor.gray
            cell.productStatus.shadowOffset = CGSize(width: 0.5, height: 0.5)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row clicked")
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "DetailGearViewController") as! DetailGearViewController
        
        let imageSlug = "\(userID!)-\(gearItems[indexPath.row])"
        
        // Load product image to subview
        if let pImg = self.productImages[imageSlug] {
            vc.getImage = pImg
        } else {
            vc.getImage = UIImage(named: gearItems[indexPath.row])!
        }
        
        
        
        vc.getPrice = gearPrices[indexPath.row]
        vc.getName = gearItems[indexPath.row]
        vc.getCondition = gearCondition[indexPath.row]
        
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // function to load referenceURL for the item
    func loadImageForItem(itemSlug: String) -> StorageReference {
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("\(itemSlug).png")
        return reference
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gearTable.rowHeight = 200
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        // Query all items where the field is equal to ...
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            userID = user.uid
            db.collection("items").whereField("owner_UID", isEqualTo: userUID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents from authenticated user: \(error)")
                        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        for document in querySnapshot!.documents {
                            let docData = document.data()
                            self.gearItems.append(docData["item_name"] as! String)
                            let priceStr = docData["price_per_day"] as! String
                            self.gearPrices.append("$" + priceStr)
                             let conditionStr = docData["item_condition"] as! String
                            self.gearCondition.append(conditionStr)
                            let statusStr = docData["status"] as! String
                            self.gearStatus.append(statusStr)
                            print("\(document.documentID) => \(document.data())")
                        }
                        self.gearTable.reloadData()
                        print("GearViewController")
                        print(self.gearItems)
                        
                    }
                }
            } else {
                print("Unable to validate user and query their gear")
            
                }
            }
    

}
