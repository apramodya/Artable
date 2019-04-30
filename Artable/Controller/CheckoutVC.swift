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

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.cartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.cartItemCell)
    }

    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    @IBAction func shippingMethodClicked(_ sender: Any) {
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cartItemCell, for: indexPath) as? CartItemCell {
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(item: product)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
