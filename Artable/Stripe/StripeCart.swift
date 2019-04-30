//
//  StripeCart.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 30/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCent = 30
    var shippingFee = 0
    
    var subTotal: Int {
        var amount = 0
        for item in cartItems {
            let priceCents = Int(item.price * 100)
            amount += priceCents
        }
        return amount
    }
    
    var processingFee: Int {
        return (subTotal == 0) ? 0 : Int(stripeCreditCardCut * Double(subTotal)) + flatFeeCent
    }
    
    var total: Int {
        return subTotal + processingFee + shippingFee
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
}
