//
//  UserService.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 27/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let userService = _UserSerivce()

final class _UserSerivce {
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListner: ListenerRegistration? = nil
    var favoritesListner: ListenerRegistration? = nil
    
    var isGuest: Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListner = userRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return}
            self.user = User.init(data: data)
        })
        
        let favsRef = userRef.collection("favorites")
        favoritesListner = favsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func favoriteSelected(product: Product) {
        let favsRef = Firestore.firestore().collection("users").document(user!.id).collection("favorites")
        
        if favorites.contains(product) {
            favorites.removeAll{ $0 == product}
            favsRef.document(product.id).delete()
        } else {
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser() {
        userListner?.remove()
        userListner = nil
        favoritesListner?.remove()
        favoritesListner = nil
        user = User()
        favorites.removeAll()
    }
}
