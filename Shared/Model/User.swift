//
//  User.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 25/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    var stripeId: String
    
    init?() {
        return nil
    }
    
    init(id: String, email: String, username: String, stripeId: String) {
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
    }
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
    }
    
    static func modelToData(user: User) -> [String: Any]{
        let data : [String: Any] = [
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "stripeId" : user.stripeId
        ]
        
        return data
    }
}
