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
    var timeStamp: Timestamp
    var stock: Int
    
    init(name: String, id: String, category: String, price: Double, productDescription: String, imageUrl: String, timeStamp: Timestamp, stock: Int = 0) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imageUrl
        self.stock = stock
        self.timeStamp = timeStamp
    }
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.stock = data["isActive"] as? Int ?? 0
        self.timeStamp = data["timestamps"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(product: Product) -> [String: Any]{
        let data : [String: Any] = [
            "name" : product.name,
            "id" : product.id,
            "category" : product.category,
            "price" : product.price,
            "productDescription" : product.productDescription,
            "imageUrl" : product.imageUrl,
            "stock": product.stock,
            "timeStamp": product.timeStamp
        ]
        
        return data
    }
}

extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
