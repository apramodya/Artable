//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by Pramodya Abeysinghe on 25/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {

    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescriptionTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var productBtn: RoundedButton!
    
    
    var selectedCategory: Category!
    var productToEdit: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productBtn.setTitle("Save changes", for: .normal)
            productNameTxt.text = product.name
            productPriceTxt.text = String(product.price)
            productDescriptionTxt.text = product.productDescription
            
            if let url = URL(string: product.imageUrl) {
                productImgView.contentMode = .scaleAspectFill
                productImgView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped() {
        launchImgPicker()
    }
    
    @IBAction func addClicked(_ sender: Any) {
            uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        guard let image = productImgView.image,
            let productName = productNameTxt.text, productName.isNotEmpty,
            let productPrice = productPriceTxt.text, productPrice.isNotEmpty,
            let productDescription = productDescriptionTxt.text, productDescription.isNotEmpty else {
                simpleAlert(title: "Error", message: "Some fields are missing")
                return
        }
        
        indicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload image")
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, message: "Unable to retrieve image url")
                    return
                }
                
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
                self.indicator.stopAnimating()
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        let price = Double(productPriceTxt.text!)!
        var product = Product.init(name: productNameTxt.text!, id: "", category: selectedCategory.id, price: price, productDescription: productDescriptionTxt.text, imageUrl: url, timeStamp: Timestamp())
        
        if let productToEdit = productToEdit {
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to add product")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, message msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", message: msg)
        indicator.stopAnimating()
    }
}

extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func launchImgPicker() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let img = info[.originalImage] as? UIImage else { return }
        
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = img
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
