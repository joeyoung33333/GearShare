//
//  DetailGearViewController.swift
//  GearShare
//
//  Created by Joe Young on 12/4/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit

// Approval subview - This view controller allows user to make owners to approve or reject rental requests for their products. Owners could see detail profile information of the user making the request to help inform their decision.

class DetailGearViewController: UIViewController {
    // set up product variables that will be seen during approval
    var getName = String()
    var getPrice = String()
    var getDate = String()
    var getImage = UIImage()
    
    // outlets to show information in a view
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailStartDate: UILabel!
    @IBOutlet weak var detailEndDate: UILabel!
    
    // dismiss current view controller
    @IBAction func backToTable(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.image = getImage
        detailName.text = getName
        //detailPrice.text = getPrice
        
        let splitedRentalDates = getDate.split(separator: "/")
        
        detailStartDate.text = String(splitedRentalDates[0]) as String
        detailEndDate.text = String(splitedRentalDates[1]) as String
        
        

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
