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
    var getName = String()
    var getPrice = String()
    var getCondition = String()
    var getImage = UIImage()
    
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detialPrice: UILabel!
    @IBOutlet weak var detialCondtion: UILabel!
    
    //Dimiss current view controller
    @IBAction func backToTable(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.image = getImage
        detailName.text = getName
        detialPrice.text = getPrice
        detialCondtion.text = getCondition

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
