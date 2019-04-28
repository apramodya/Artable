//
//  CheckoutVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 29/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    @IBAction func shippingMethodClicked(_ sender: Any) {
    }
}
