//
//  PurchaseHelper.swift
//  PetMaster
//
//  Created by Fedor Sychev on 25.08.2021.
//

import Foundation
import Purchases

class PurchaseService {
    static func purchase(productId: String?, successfulPurchase: @escaping () -> Void) {
        guard productId != nil else {
            return
        }
        
        //get SKPrudoct
        Purchases.shared.products([productId!]) { (products) in
            if !products.isEmpty {
                let skProduct = products[0]
                
                Purchases.shared.purchaseProduct(skProduct) { transaction, purchaserInfo, error, userCanceled in
                    
                    if error == nil && !userCanceled {
                        //successful purchase
                        successfulPurchase()
                    }
                }
            }
        }
    }
}
