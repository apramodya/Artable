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
