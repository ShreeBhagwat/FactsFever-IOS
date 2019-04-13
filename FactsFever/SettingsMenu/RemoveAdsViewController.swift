//
//  RemoveAdsViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 25/03/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit
import StoreKit
import ProgressHUD

class RemoveAdsViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var product: SKProduct?
    var ProductID = "com.shreebhagwat.factsfever.RemoveAds1"
    @IBOutlet weak var descriptionLabelOutlet: UILabel!
    @IBOutlet weak var removeAdsLabelOutlet: UILabel!
    @IBOutlet weak var restorePurchaseButtonOutlet: UIButton!
    @IBOutlet weak var purchaseButtonOutlet: UIButton!
    @IBOutlet weak var removeAdsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8258904602, blue: 0.08854053572, alpha: 1)

        purchaseButtonOutlet.isEnabled = false
        let save =  UserDefaults.standard
        if save.value(forKey: "purchase") == nil {
            SKPaymentQueue.default().add(self)
            getPurchaseInfo()
            ProgressHUD.show("Getting Payment Data. Hold on")

        }else{
            removeAdsLabelOutlet.text = "Thank You"
            descriptionLabelOutlet.text = "Enjoy the app with ad free experience"
            removeAdsImageView.image = #imageLiteral(resourceName: "crown")
            purchaseButtonOutlet.isEnabled = false
            purchaseButtonOutlet.setTitle("Already Purchased", for: .normal)
            restorePurchaseButtonOutlet.isEnabled = false
         
        }
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        restorePurchaseButtonOutlet.layer.cornerRadius = restorePurchaseButtonOutlet.frame.height * 0.5
        restorePurchaseButtonOutlet.clipsToBounds = true
        purchaseButtonOutlet.layer.cornerRadius = purchaseButtonOutlet.frame.height * 0.5
        purchaseButtonOutlet.clipsToBounds = true
        navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        
        removeAdsLabelOutlet.text = "Getting Info..."
        descriptionLabelOutlet.text = "Please Wait......"
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
    }
    
    @IBAction func restorePurchaseButtonPressed(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getPurchaseInfo(){
        
        if SKPaymentQueue.canMakePayments(){
            let request = SKProductsRequest(productIdentifiers: NSSet(object: self.ProductID) as! Set<String>)
            request.delegate = self
            request.start()
            ProgressHUD.dismiss()
        } else {
            ProgressHUD.dismiss()
            removeAdsLabelOutlet.text = "Warning"
            descriptionLabelOutlet.text = "Please enable in app purchases in your phone settings"
        }
        
    }
    
    
    //MARK:- Delegate Methods
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        ProgressHUD.dismiss()
        var products = response.products
        
        if(products.count == 0){
            removeAdsLabelOutlet.text = "Error"
            descriptionLabelOutlet.text = "Product not found. Check internet Connection or in app purchase settings"
        }else {
            product = products[0]
            removeAdsLabelOutlet.text = "Remove Ads"
            purchaseButtonOutlet.isEnabled = true
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product!.priceLocale
            let price = numberFormatter.string(from: product!.price)
            purchaseButtonOutlet.setTitle("\(price!)", for: .normal)
        }
        let invalids = response.invalidProductIdentifiers
        for product in invalids {
            removeAdsLabelOutlet.text = "Error"
            descriptionLabelOutlet.text = "Invalid Product"
            
            print("Products........\(products)")
            print(" Invalid......\(invalids)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        ProgressHUD.dismiss()
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                removeAdsLabelOutlet.text = "Purchase Successfull"
                descriptionLabelOutlet.text = "Thank you for your support !"
                removeAdsImageView.image = #imageLiteral(resourceName: "crown")
                purchaseButtonOutlet.isEnabled = false
                purchaseButtonOutlet.isHidden = true
                let save = UserDefaults.standard
                save.set(true, forKey: "purchase")
                save.synchronize()
            case .purchasing:
                removeAdsLabelOutlet.text = "Purchasing......"
                descriptionLabelOutlet.text = " Please Wait......."
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                removeAdsLabelOutlet.text = "Warning"
                descriptionLabelOutlet.text = "There was some error in payment. Try again"
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                removeAdsLabelOutlet.text = "App Restored"
                descriptionLabelOutlet.text = "Your app has been restored with all the in app purchases"
                removeAdsImageView.image = #imageLiteral(resourceName: "crown")
                purchaseButtonOutlet.isEnabled = false
                purchaseButtonOutlet.isHidden = true
                let save = UserDefaults.standard
                save.set(true, forKey: "purchase")
                save.synchronize()
                break
            case .deferred:
                break
            
            }
        }
        
    }
    
    
    
    
    
    
}
