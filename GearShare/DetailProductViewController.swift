//
//  DetailProductViewController.swift
//  GearShare
//
//  Created by Joe Young on 12/4/18.
//  Copyright © 2018 cs.nyu.edu. All rights reserved.
//

import UIKit



class DetailProductViewController: UIViewController {
    
    var getName = String()
    var getPrice = String()
    var getCondition = String()
    var getImage = UIImage()
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailItemName: UILabel!
    @IBOutlet weak var detailPricePerDay: UILabel!
    @IBOutlet weak var detailItemCondition: UILabel!
    
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
