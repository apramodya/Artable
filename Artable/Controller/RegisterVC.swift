//
//  RegisterVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 7/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var passwordImg: UIImageView!
    @IBOutlet weak var confirmPasswordImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passwordText = passwordTxt.text else { return}
        
        if textField == confirmPasswordTxt {
            passwordImg.isHidden = false
            confirmPasswordImg.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordImg.isHidden = true
                confirmPasswordImg.isHidden = true
                confirmPasswordTxt.text = ""
            }
        }
        
        if passwordTxt.text == confirmPasswordTxt.text {
            passwordImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPasswordImg.image = UIImage(named: AppImages.GreenCheck)
        } else {
            passwordImg.image = UIImage(named: AppImages.RedCheck)
            confirmPasswordImg.image = UIImage(named: AppImages.RedCheck)
        }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty,
            let username = usernameTxt.text, username.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", message: "Some fields are missing.")
                return
        }
        
        guard let confirmPassword = confirmPasswordTxt.text, confirmPassword == password else {
            simpleAlert(title: "Error", message: "Passwords do not match.")
            return
        }

        spinner.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
                self.spinner.stopAnimating()
                return
            }
            
            guard let firUser = result?.user else { return}
            let artUser = User(id: firUser.uid, email: email, username: username, stripeId: "")
            
            self.createFireUser(user: artUser)
        }
        
//        guard let authUser = Auth.auth().currentUser else { return}
//
//        let credentail = EmailAuthProvider.credential(withEmail: email, password: password)
//        authUser.linkAndRetrieveData(with: credentail) { (result, error) in
//
//            if let error = error {
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//                debugPrint(error)
//                self.spinner.stopAnimating()
//                return
//            }
//
//            self.spinner.stopAnimating()
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    func createFireUser(user: User) {
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        let data = User.modelToData(user: user)
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.spinner.stopAnimating()
            return
        }
    }
}
