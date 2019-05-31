//
//  Extensions.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 8/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Int {
    func centsToFormattedCurrency() -> String {
        let unit = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let unitString = formatter.string(from: unit as NSNumber) {
            return unitString
        }
        
        return formatter.string(from: 0 as NSNumber)!
    }
}
