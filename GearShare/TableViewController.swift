//
//  TableViewController.swift
//  GearShare
//
//  Created by Larry Liu on 12/3/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseUI

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db = Firestore.firestore()
    @IBOutlet weak var myHeadLabel: UILabel!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myDuration: UITextField!
    
    // test cases
    var products = [String]()
    var prices = [String]()
    var condition = [String]()
    var documents = [String]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //cell.myImage.image = UIImage(named: products[indexPath.row])
        
        // Code for loading image with SDWebImage
        let placeholderImage = UIImage(named: products[indexPath.row])
        let itemImageRef = loadImageForItem(itemSlug: "\(documents[indexPath.row])")
        cell.myImage.sd_setImage(with: itemImageRef, placeholderImage: placeholderImage!)
        
        cell.myLabel.text = products[indexPath.row]
        cell.myPrice.text = prices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row clicked")
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "DetailProductViewController") as! DetailProductViewController
        vc.getImage = UIImage(named: products[indexPath.row])!
        vc.getPrice = prices[indexPath.row]
        vc.getName = products[indexPath.row]
        vc.getCondition = condition[indexPath.row]
        vc.getItemID = documents[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //Function to load image from storage
    func loadImageForItem(itemSlug: String) -> StorageReference {
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("\(itemSlug).png")
        return reference
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("items").getDocuments() { (querySnapshot, err) in
            print("All Documents")
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    let itemName = docData["item_name"] as! String
                    self.products.append(itemName)
                    let priceStr = docData["price_per_day"] as! String
                    self.prices.append("$" + priceStr)
                    let conditionStr = docData["item_condition"] as! String
                    self.condition.append(conditionStr)
                    let uid = docData["owner_UID"] as! String
                    let documentName = "\(String(describing: uid))-\(String(describing: itemName))"
                    self.documents.append(documentName)
                    print("\(document.documentID) => \(document.data())")
                }
                print(self.products)
                print(self.prices)
                self.myTable.reloadData()
            }
        }
        self.myTable.rowHeight = 200
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func buttonPress(_ sender: Any) {
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
