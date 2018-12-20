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

// Gear view - This view controller allows product owners to review requests for rentals, uesrs can either approve or reject requests with renter's information provided 

class GearViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var segmentBar: UISegmentedControl!
    @IBOutlet weak var gearTable: UITableView!
    var db = Firestore.firestore()
    

    
    // test cases
    var gearItems = [String]()
    var gearPrices = [String]()
    var gearRentalPeriod = [String]()
    var gearStatus = [String]()
    var reqUsers = [String]()
    var reqUsersRating = [String]()
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
        
        // code for loading image with SDWebImage
        let placeholderImage = UIImage(named: gearItems[indexPath.row])

        // code for loading image with SDWebImage
        let storageRef = Storage.storage().reference()
        let imageSlug = "\(userID!)-\(gearItems[indexPath.row])"
        let reference = storageRef.child("\(imageSlug).png")
        reference.downloadURL { url, error in
            if let error = error {
                print(error)
                cell.productImage.image = UIImage(named: self.gearItems[indexPath.row])
            } else {
                cell.productImage.sd_setImage(with: url, placeholderImage: placeholderImage, completed: { (image, error, type, url) in
                    if let error = error {
                        print (error)
                    } else {
                        // cell.productImage.image?.imageOrientation
                        self.productImages[imageSlug] = image
                        print ("Image loaded")
                    }
                })
            }
            
        }
        
        // cell.productImage.image = UIImage(named: gearItems[indexPath.row])
        cell.productName.text = gearItems[indexPath.row]
        cell.productPrice.text = gearPrices[indexPath.row]
        // set up requests for products
        if (gearStatus[indexPath.row] == "available") {
            cell.productStatus.text = gearStatus[indexPath.row]
            cell.productStatus.textColor = UIColor.green
            cell.productStatus.shadowColor = UIColor.gray
            cell.productStatus.shadowOffset = CGSize(width: 0.5, height: 0.5)
        } else if (gearStatus[indexPath.row] == "requested") {
            cell.productStatus.text = gearStatus[indexPath.row]
            cell.productStatus.textColor = UIColor.yellow
            cell.productStatus.shadowColor = UIColor.gray
            cell.productStatus.shadowOffset = CGSize(width: 0.5, height: 0.5)
        } else {
            cell.productStatus.text = gearStatus[indexPath.row]
            cell.productStatus.textColor = UIColor.red
            cell.productStatus.shadowColor = UIColor.gray
            cell.productStatus.shadowOffset = CGSize(width: 0.5, height: 0.5)
            
        }
        
        return cell
    }
    @IBAction func reloadButton(_ sender: Any) {
        gearItems = [String]()
        gearPrices = [String]()
        gearRentalPeriod = [String]()
        gearStatus = [String]()
        self.loadData()
        self.gearTable.reloadData()
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
            vc.getImage = UIImage(named: "blank_camera")!
        }
        // set up next view controller to be shown
        vc.getPrice = gearPrices[indexPath.row]
        vc.getStatus = gearStatus[indexPath.row]
        print(gearStatus[indexPath.row])
        vc.getName = gearItems[indexPath.row]
        vc.getDate = gearRentalPeriod[indexPath.row]
        vc.getUser = reqUsers[indexPath.row]
        vc.getUserRating = reqUsersRating[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadData(){
        self.gearTable.rowHeight = 200
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        // Query all items where the field is equal to ...
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            userID = user.uid
            /*
            var query = ""
            if (self.segmentBar.selectedSegmentIndex==0) {
                query = "owner_UID"
            } else {
                //query
            }
 */
            db.collection("items").whereField("owner_UID", isEqualTo: userUID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents from authenticated user: \(error)")
                        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        // add correct gear into the table based on the current user
                        for document in querySnapshot!.documents {
                            let docData = document.data()
                            self.gearItems.append(docData["item_name"] as! String)
                            let priceStr = docData["price_per_day"] as! String
                            self.gearPrices.append("$" + priceStr)
                            //let conditionStr = docData["item_condition"] as! String
                            let reqStartDate = docData["req_pick_up_date"] as! String
                            let reqEndDate = docData["req_return_date"] as! String
                            self.gearRentalPeriod.append("\(reqStartDate)/\(reqEndDate)")
                            let statusStr = docData["status"] as! String
                            self.gearStatus.append(statusStr)
                            let reqUser = docData["req_user_UID"] as! String
                            self.reqUsers.append(reqUser)
                            
                            if (reqUser != "") {
                                let docRef = self.db.collection("users").document("\(reqUser)")
                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let userProfile = document.data()
                                        let userRating = userProfile?["rating"] as? String ?? ""
                                        print("Document data: \(userRating)")
                                        self.reqUsersRating.append(userRating)
                                    } else {
                                        print("Document does not exist")
                                        self.reqUsersRating.append("")
                                    }
                                }
                            } else {
                                self.reqUsersRating.append("")
                            }
                            
                            print("\(document.documentID) => \(document.data())")
                        }
                        // input the data into the table
                        self.gearTable.reloadData()
                        print("GearViewController")
                        print(self.gearItems)
                    }
            }
        } else {
            print("Unable to validate user and query their gear")
        }
    }
    
    // function to load referenceURL for the item
    func loadImageForItem(itemSlug: String) -> StorageReference {
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("\(itemSlug).png")
        return reference
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
            }
}
