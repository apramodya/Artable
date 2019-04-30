//
//  Constants.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 8/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginSB"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let Placeholder = "placeholder"
}

struct AppColor {
    static let Blue = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
    static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
}

struct Identifiers {
    static let categoryCell = "CategoryCell"
    static let productCell = "ProductCell"
    static let cartItemCell = "CartItemCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "toAddEditCategory"
    static let ToEditCategory = "toEditCategory"
    static let ToAddEditProduct = "toAddEditProduct"
    static let ToFavorites = "toFavorites"
}
