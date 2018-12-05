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

class DetailProductViewController: UIViewController {
    
    var db = Firestore.firestore()
    
    var getName = String()
    var getPrice = String()
    var getCondition = String()
    var getImage = UIImage()
    var getItemID = String()
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailItemName: UILabel!
    @IBOutlet weak var detailPricePerDay: UILabel!
    @IBOutlet weak var detailItemCondition: UILabel!
    
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
            }
        }
         */
        
        let user = Auth.auth().currentUser
        if let user = user {
            let userUID = user.uid
            
            db.collection("items").whereField("owner_UID", isEqualTo: userUID)
                .getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Unable to get current user to request")
                        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        docRef.updateData([
                            "status": "requested",
                            "req_user_UID": userUID
                        ]) { err in
                            if let err = err {
                                print("Error in updating entry \(err)")
                            } else {
                                print("Update item status successful");
                            }
                        }
                        }
                        
                    }
        } else{
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
