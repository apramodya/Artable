//
//  CheckoutVC.swift
//  Artable
//
//  Created by Pramodya Abeysinghe on 29/4/19.
//  Copyright © 2019 Pramodya Abeysinghe. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckoutVC: UIViewController, CartItemCellDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // variable
    var paymentContext: STPPaymentContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.cartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.cartItemCell)
    }
    
    func setupPaymentInfo() {
        subtotalLbl.text = StripeCart.subTotal.centsToFormattedCurrency()
        processingFeeLbl.text = StripeCart.processingFee.centsToFormattedCurrency()
        shippingCostLbl.text = StripeCart.shippingFee.centsToFormattedCurrency()
        totalLbl.text = StripeCart.total.centsToFormattedCurrency()
    }
    
    func removeItem(item: Product) {
        StripeCart.removeItemFromCart(item: item)
        tableView.reloadData()
        setupPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
    }
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.createCardSources = true
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        spinner.startAnimating()
        paymentContext.requestPayment()
    }
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentMethodsViewController()
    }
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
}

extension CheckoutVC: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodBtn.setTitle("Select Method", for: .normal)
        }
        
        if let shippinMethod = paymentContext.selectedShippingMethod {
            shippingMethodBtn.setTitle(shippinMethod.label, for: .normal)
            StripeCart.shippingFee = Int(Double(truncating: shippinMethod.amount) * 100)
            setupPaymentInfo()
        } else {
            shippingMethodBtn.setTitle("Select Method", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let ups = PKShippingMethod()
        ups.amount = 0
        ups.label = "UPS"
        ups.detail = "Arrives in 3-5 days"
        ups.identifier = "ups"
        
        let fedex = PKShippingMethod()
        fedex.amount = 4.99
        fedex.label = "FedEx"
        fedex.detail = "Arrives tomorrow"
        fedex.identifier = "fedex"
        
        if address.country == "US" {
            completion(.valid, nil, [ups, fedex], nil)
        } else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        spinner.stopAnimating()
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let data: [String: Any] = [
            "total": StripeCart.total,
            "customerId": userService.user?.stripeId,
            "idempotency": idempotency
        ]
        Functions.functions().httpsCallable("makeCharge").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", message: "Unable to make charge")
                completion(error)
                return
            }
            
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setupPaymentInfo()
            completion(nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        
        switch status {
        case .error:
            spinner.stopAnimating()
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            spinner.stopAnimating()
            title = "Success"
            message = "Thanks for your purchase"
        case .userCancellation:
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.cartItemCell, for: indexPath) as? CartItemCell {
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
