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
    
    static func setupBackground(controller: UIViewController){
        controller.view.insetsLayoutMarginsFromSafeArea = false
        controller.view.contentMode = .scaleAspectFill
        controller.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background1"))
    }
    
    static func setupTextField(field: UITextField) {
        let width = CGFloat(2.0)
        let border1 = CALayer()
        border1.borderColor = UIColor.darkGray.cgColor
        border1.frame = CGRect(x: 0, y: field.frame.size.height + 9, width: field.frame.size.width + 20, height: field.frame.size.height + 9)
        border1.borderWidth = width
        
        let border2 = CALayer()
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: 0, width: field.frame.size.width + 20, height: field.frame.size.height)
        border2.borderWidth = width
        
        let border3 = CALayer()
        border3.borderColor = UIColor.darkGray.cgColor
        border3.frame = CGRect(x: field.frame.width + 13, y: 0, width: 4, height: field.frame.size.height)
        border3.borderWidth = width
        field.layer.addSublayer(border2)
        field.layer.addSublayer(border1)
        field.layer.addSublayer(border3)
        field.layer.masksToBounds = true
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name: "Avenir Next Medium", size: 26)
    }
    
    static func setupTextField_Type2(field: UITextField) {
        let width = CGFloat(2.0)
        let border1 = CALayer()
        border1.borderColor = UIColor.darkGray.cgColor
        border1.frame = CGRect(x: 0, y: field.frame.size.height + 9, width: field.frame.size.width + 20, height: field.frame.size.height)
        border1.borderWidth = width

        field.layer.addSublayer(border1)
        field.layer.masksToBounds = true
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name: "Avenir Next Medium", size: 26)
    }
    
    static func setupViewBehindTable(tableView: UITableView) {
        var frame = tableView.bounds
        frame.origin.y = -frame.size.height
        let backView = UIView(frame: frame)
        backView.backgroundColor = UIColor(red: 255/255, green: 159/255, blue: 74/255, alpha: 1)
        tableView.addSubview(backView)
    }
    
    static func setupGradierntTextView(field: UITextField) {
    }
}

extension String{
    func localized(tableName: String = "Localizable") -> String{
        return NSLocalizedString(self, comment: "")
    }
}
