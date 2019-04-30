//
//  CartItemCell.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 29/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Kingfisher

class CartItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(item: Product) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: item.price as NSNumber) {
            productTitleLbl.text = "\(item.name) \(price)"
        }
        
        if let url = URL(string: item.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
    }
    
}
