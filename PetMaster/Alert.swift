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
        showBasicAlert(on: vc, with: NSLocalizedString("no_data_header", comment: ""), message: NSLocalizedString("no_data", comment: ""))
    }
    
    static func showShareAlert(on vc: SettingsTableViewController) {
        let alert = UIAlertController(title: NSLocalizedString("warning", comment: ""), message: NSLocalizedString("have_to_share", comment: ""), preferredStyle: .alert)
        
        let shareAction = UIAlertAction(title: NSLocalizedString("share", comment: ""), style: .default) { (_) in
            vc.Share()
        }
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
