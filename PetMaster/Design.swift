//
//  Design.swift
//  PetMaster
//
//  Created by Fedor Sychev on 10.08.2021.
//

import Foundation
import UIKit

class Design{
    
    static func SetupBaseButton(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 233/255, green: 91/255, blue: 19/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 26)
        button.layer.cornerRadius = button.frame.size.height/2
    }
    
    static func SetupGreenButton(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 0/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 26)
        button.layer.cornerRadius = button.frame.size.height/2
    }
}
