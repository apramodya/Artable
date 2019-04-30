//
//  ProductDetailVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 23/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productTitle.text = product.name
        productDescription.text = product.productDescription

        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addCartClicked(_ sender: Any) {
        StripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
