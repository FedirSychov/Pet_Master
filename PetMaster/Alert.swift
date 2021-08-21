//
//  Alert.swift
//  PetMaster
//
//  Created by Fedor Sychev on 10.08.2021.
//

import Foundation
import UIKit

struct Alert{
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "No data", message: "Please fill out at least name field!")
    }
    
    static func showShareAlert(on vc: SettingsTableViewController) {
        let alert = UIAlertController(title: "Warning!", message: "To unlock backgrounds pls share an app with your friends.", preferredStyle: .alert)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (_) in
            vc.Share()
        }
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
