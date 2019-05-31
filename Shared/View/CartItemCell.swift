//
//  CartItemCell.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 29/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Kingfisher

protocol CartItemCellDelegate: class {
    func removeItem(item: Product)
}

class CartItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    weak var delegate: CartItemCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(product: Product, delegate: CartItemCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLbl.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(item: product)
    }
    
}
