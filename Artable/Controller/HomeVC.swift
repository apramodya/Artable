//
//  ViewController.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 7/3/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var loginLogoutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cat = Category.init(name: "q", id: "1", imageUrl: "https://hi.org/sn_uploads/Campagne/Olivier.jpg", isActive: true, timeStamp: Timestamp())
        categories.append(cat)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.categoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.categoryCell)
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginLogoutBtn.title = "Logout"
        } else {
            loginLogoutBtn.title = "Login"
        }
    }

    fileprivate func presentLoginController() {
        let stroyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = stroyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func loginLogoutClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return}
        
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                    }
                    self.presentLoginController()
                }
            } catch {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.categoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCategory(category: categories[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 50 ) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
