//
//  Category.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 9/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import Foundation
import Firebase

struct Category {
    var name: String
    var id: String
    var imageUrl: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
