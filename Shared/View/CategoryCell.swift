//
//  CategoryCell.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 9/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImg.layer.cornerRadius = 5
    }

    func configureCategory(category: Category) {
        categoryLbl.text = category.name
        if let url = URL(string: category.imageUrl) {
            let placeholderImage = UIImage(named: "placeholder")
            categoryImg.kf.indicatorType = .activity
            categoryImg.kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(.fade(0.2))])
        }
    }
}
