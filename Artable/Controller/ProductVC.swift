//
//  ProductVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 10/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Firebase

class ProductVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var products = [Product]()
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product.init(name: "product", id: "1", category: "1", price: 2.2, productDescription: "", imageUrl: "https://hi.org/sn_uploads/Campagne/Olivier.jpg", timestamp: Timestamp(), stock: 3, favorite: true)
        products.append(product)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.productCell, bundle: nil), forCellReuseIdentifier: Identifiers.productCell)
    }
}

extension ProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.productCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
