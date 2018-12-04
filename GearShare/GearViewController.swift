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

class GearViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gearTable: UITableView!
    var db = Firestore.firestore()
    var gearItems = [String]()
    var gearPrices = [String]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gearItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GearCell
        cell.productImage.image = UIImage(named: (gearItems[indexPath.row] + ".jpg"))
        cell.productName.text = gearItems[indexPath.row]
        cell.productPrice.text = gearPrices[indexPath.row]
        return cell
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
            
            db.collection("rental").whereField("owner_UID", isEqualTo: userUID)
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
                            print("\(document.documentID) => \(document.data())")
                        }
                        self.gearTable.reloadData()
                    }
                }
            } else {
                print("Unable to validate user and query their gear")
            
                }
            }
    

}
