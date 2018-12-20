//
//  DetailGearViewController.swift
//  GearShare
//
//  Created by Joe Young on 12/4/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

// Approval subview - This view controller allows user to make owners to approve or reject rental requests for their products. Owners could see detail profile information of the user making the request to help inform their decision.

class DetailGearViewController: UIViewController {
    var db = Firestore.firestore()
    
    // set up product variables that will be seen during approval
    var getName = String()
    var getPrice = String()
    var getDate = String()
    var getImage = UIImage()
    var getStatus = String()
    var getUser = String()
    var getUserRating = String()
    
    @IBOutlet weak var inputUserRating: UITextField!
    @IBOutlet weak var denyBtn: RoundedButton!
    @IBOutlet weak var confirmBtn: RoundedButton!
    // outlets to show information in a view
    @IBOutlet weak var approveBtn: RoundedButton!
    
    @IBOutlet weak var detailUserRating: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailUser: UILabel!
    @IBOutlet weak var detailStartDate: UILabel!
    @IBOutlet weak var detailEndDate: UILabel!
    
    // dismiss current view controller
    @IBAction func backToTable(_ sender: Any) {
        // get the current user
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            let docRef = db.collection("items").document("\(userUID)-\(getName)")
            // pull user address from users db
            docRef.updateData([
                "status": "available",
                "req_user_UID": "",
                "req_pick_up_date": "",
                "req_return_date": ""
            ]) { error in
                if let error = error {
                    print("Error in updating entry \(error)")
                    let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            
            }
        } else {
            print ("ERROR!")
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func approveReq(_ sender: Any) {
        // get the current user
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            let docRef = db.collection("items").document("\(userUID)-\(getName)")
            // pull user address from users db
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let product = document.data()
                    let reqUser = product?["req_user_UID"] as? String ?? ""
                    //let reqPickUpDate = product?["req_pick_up_date"] as? String ?? ""
                    //let reqReturnDate = product?["req_return_date"] as? String ?? ""
                    print("Request user: \(reqUser)")
                    docRef.updateData([
                        "status": "approved",
                        "curr_renter_UID": reqUser,
                    ])
                } else {
                    // show that user address has not been added
                    //self.EditUserAddress.text = "Not added"
                    print("Document does not exist")
                }
            }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    }
    
    @IBAction func confirmReturn(_ sender: Any) {
        // get the current user
        
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            let docRef = db.collection("items").document("\(userUID)-\(getName)")
            // pull user address from users db
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let product = document.data()
                    let currRentalUserID = product?["curr_renter_UID"] as? String ?? ""
                    //let reqPickUpDate = product?["req_pick_up_date"] as? String ?? ""
                    //let reqReturnDate = product?["req_return_date"] as? String ?? ""
                    print("Current rental user: \(currRentalUserID)")
                    
                    docRef.updateData([
                        "status": "available",
                        "req_user_UID": "",
                        "req_pick_up_date": "",
                        "req_return_date": ""
                    ]) { error in
                        if let error = error {
                            print("Error in updating entry \(error)")
                            let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    
                    //docRef for user profile
                    let docRefUser = self.db.collection("users").document("\(currRentalUserID)")
                    
                    docRefUser.updateData([
                        "rating": self.inputUserRating.text ?? String()
                    ]) { error in
                        if let error = error {
                            print("Error in updating entry \(error)")
                            let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
            }
        }
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.image = getImage
        detailName.text = getName
        detailUser.text = getUser
        detailUserRating.text = getUserRating
        //detailPrice.text = getPrice
        print(getDate)
        if(getDate != "/"){
            let splitedRentalDates = getDate.split(separator: "/")
            detailStartDate.text = String(splitedRentalDates[0]) as String
            detailEndDate.text = String(splitedRentalDates[1]) as String
        } else{
            detailStartDate.text = ""
            detailEndDate.text = ""
        }
        
        if (getStatus=="approved") {
            self.confirmBtn.isHidden = false
            self.denyBtn.isHidden = true
            self.approveBtn.isHidden = true
            self.inputUserRating.isHidden = false
        } else {
            self.confirmBtn.isHidden = true
            self.denyBtn.isHidden = false
            self.approveBtn.isHidden = false
            self.inputUserRating.isHidden = true
        }
        
        
        

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
