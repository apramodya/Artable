//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 9/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please enter email")
            return}
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
