//
//  DetailProductViewController.swift
//  GearShare
//
//  Created by Joe Young on 12/4/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

// Product subview - This view controller allows user to make rental requests to product owners. User should specific rental periods to help product owners make their approval judgments

class DetailProductViewController: UIViewController {
    
    var db = Firestore.firestore()
    
    // set up the product view variables
    var getName = String()
    var getPrice = String()
    var getCondition = String()
    var getImage = UIImage()
    var getItemID = String()
    
    // outlets
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailItemName: UILabel!
    @IBOutlet weak var detailPricePerDay: UILabel!
    @IBOutlet weak var detailItemCondition: UILabel!
    @IBOutlet weak var pickUpDate: UIDatePicker!
    
    @IBOutlet weak var returnDate: UIDatePicker!
    
    @IBAction func backToTable(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // make request for an item, changes status of item in database, and records renter's profile
    @IBAction func Request_Item(_ sender: Any) {
        let docRef = db.collection("items").document(self.getItemID)
        print(getItemID)
        /*
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist. Unable to request")
3        }
         */
        
        //Format input from date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let pickUpDate = dateFormatter.string(from: self.pickUpDate.date)
        let returnDate = dateFormatter.string(from: self.returnDate.date)
        print("Pick up: \(pickUpDate) - Return: \(returnDate)")
        
        // get the current user
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            docRef.updateData([
                "status": "requested",
                "req_user_UID": userUID,
                "req_pick_up_date": pickUpDate,
                "req_return_date": returnDate
            ]) { error in
                if let error = error {
                    print("Error in updating entry \(error)")
                    let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("Update item status successful")
                    let alertController = UIAlertController(title: "Success!", message: "You Requested an Item", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            print("Unable to authenticate user")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.image = getImage
        detailItemName.text = getName
        detailPricePerDay.text = getPrice
        detailItemCondition.text = getCondition

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
