//
//  PurchaseViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 19.08.2021.
//

import UIKit
import StoreKit

protocol madePurchaseDelegate: NSObject {
    func madePurchase()
}

class PurchaseViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    private var models = [SKProduct]()
    
    weak var madePurchaseDelegate: madePurchaseDelegate?

    @IBOutlet weak var BuyButton: UIButton!
    @IBOutlet weak var DescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.DescriptionTextField.text = NSLocalizedString("purchase_description", comment: "")
        
        fetchProducts()
        SKPaymentQueue.default().add(self)
    }
    
    private func setupView() {
        Design.SetupTextView(textView: DescriptionTextField)
        Design.setupBackground(controller: self)
        Design.SetupBaseButton(button: self.BuyButton)
    }
    
    enum Product: String, CaseIterable {
        case FullVersion = "petmasterstorage.fullversion"
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            Alert.showBasicAlert(on: self, with: "Count", message: "\(response.products.count)")
            print("Count: \(response.products.count)")
            self.models = response.products
        }
    }
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // no impl
        transactions.forEach({
            switch $0.transactionState {
            
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction($0)
                CloudHelper.SaveFullVersionToCloud(fullVersion: true)
                self.madePurchaseDelegate?.madePurchase()
                Saved.shared.currentVersion.isFullVersion = true
                self.navigationController?.popViewController(animated: true)
            case .failed:
                print("did not purchase")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    
    @IBAction func BuyAction(_ sender: Any) {
        let payment = SKPayment(product: models[0])
        SKPaymentQueue.default().add(payment)
    }
}

extension SettingsTableViewController: madePurchaseDelegate {
    func madePurchase() {
        AppVersion.isFullVersion = true
        self.tableView.reloadData()
        self.updatedelegate?.updateVersion()
    }
}
