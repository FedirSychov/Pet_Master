//
//  ChangeIcon.swift
//  PetMaster
//
//  Created by Fedor Sychev on 21.08.2021.
//

import Foundation
import UIKit

class AppIconService {
    let application = UIApplication.shared
    
    enum AppIcon: String {
        case primaryAppIcon
        case greenAppIcon
        case blueAppIcon
    }
    
    func changeAppIcon(to appIcon: AppIcon) {
        let appIconValue: String? = appIcon == .primaryAppIcon ? nil : appIcon.rawValue
        application.setAlternateIconName(appIconValue)
    }
}
