//
//  Product.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 10/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timestamp: Timestamp
    var stock: Int
    var favorite: Bool
}
