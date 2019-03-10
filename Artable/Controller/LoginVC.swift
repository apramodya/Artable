//
//  LoginVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 7/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", message: "Some fields are missing.")
                return}
        
        spinner.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.spinner.stopAnimating()
                return
            }
            
            self.spinner.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }
    
}
