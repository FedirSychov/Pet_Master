//
//  Design.swift
//  PetMaster
//
//  Created by Fedor Sychev on 10.08.2021.
//

import Foundation
import UIKit

class Design{
//MARK: - setting up buttons
    static func SetupBaseButton(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 233/255, green: 91/255, blue: 19/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 26)
        button.layer.cornerRadius = button.frame.size.height/2
    }
    
    static func setupDeactivatedButton(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 180/255, green: 91/255, blue: 19/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 26)
        button.layer.cornerRadius = button.frame.size.height/2
    }
    
    static func SetupGreenButton(button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 0/255, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 26)
        button.layer.cornerRadius = button.frame.size.height/2
    }
    
    static func SetupTextView(textView: UITextView) {
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "Avenir Next Medium", size: 26)
        textView.textAlignment = .justified
    }
    
//MARK: - setting up background
    static func setupBackground(controller: UIViewController){
        controller.view.insetsLayoutMarginsFromSafeArea = false
        controller.view.contentMode = .scaleAspectFill

        controller.view.backgroundColor = UIColor(patternImage: UIImage(named: Saved.shared.currentSettings.backgroundImage)!)
    }
    
    static func setupBarColor() {
        
    }
    
    static func setupBackgroundForTableView(tableView: UITableView) {
        tableView.backgroundView = UIImageView(image: UIImage(named: Saved.shared.currentSettings.backgroundImage)!.crop(to: CGSize(width: 2000, height: 2000)))
    }
    
    static func setupBorderStyle(imageView: UIImageView) {
        imageView.layer.borderColor = CGColor(red: CGFloat(Saved.shared.currentSettings.headerColor_red)/255, green: CGFloat(Saved.shared.currentSettings.headerColor_green)/255, blue: CGFloat(Saved.shared.currentSettings.headerColor_blut)/255, alpha: 1)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
    }
    
    static func setupTintColor(nav: UINavigationController) {
        nav.navigationBar.barTintColor = UIColor(red: CGFloat(Saved.shared.currentSettings.headerColor_red)/255, green: CGFloat(Saved.shared.currentSettings.headerColor_green)/255, blue: CGFloat(Saved.shared.currentSettings.headerColor_blut)/255, alpha: 1)
    }
    
//MARK: - setting up textFields
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
//MARK: - setting up view behind table
    static func setupViewBehindTable(tableView: UITableView) {
        var frame = tableView.bounds
        frame.origin.y = -frame.size.height
        let backView = UIView(frame: frame)
        backView.backgroundColor = UIColor(red: CGFloat(Saved.shared.currentSettings.headerColor_red)/255, green: CGFloat(Saved.shared.currentSettings.headerColor_green)/255, blue: CGFloat(Saved.shared.currentSettings.headerColor_blut)/255, alpha: 1)
        tableView.addSubview(backView)
    }

    
    static func setupBackgroundForCells(cell: UITableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: CGFloat(Saved.shared.currentSettings.cellBackground_red/255), green: CGFloat(Saved.shared.currentSettings.cellBackground_green/255), blue: CGFloat(Saved.shared.currentSettings.cellBackground_blue/255), alpha: 1)
        cell.selectedBackgroundView = backgroundView
    }
    
    static func animateLabelDisappear(label: UILabel) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            label.transform = CGAffineTransform(translationX: -25, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                label.alpha = 0
                label.transform = label.transform.translatedBy(x: 0, y: -200)
            }, completion: nil)
        }
    }
    
    static func animateLabelAppear(label: UILabel, delay: Float) {
        label.alpha = 0
        UIView.animate(withDuration: 0.0, delay: TimeInterval(delay), usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            label.transform = label.transform.translatedBy(x: 0, y: -200)
            label.alpha = 0
        } completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                label.transform = label.transform.translatedBy(x: 0, y: 200)
                label.alpha = 1
            } completion: { (_) in
                
            }

        }

    }
}

extension String{
    func localized(tableName: String = "Localizable") -> String{
        return NSLocalizedString(self, comment: "")
    }
}

extension UIImage {

func crop(to:CGSize) -> UIImage {

    guard let cgimage = self.cgImage else { return self }

    let contextImage: UIImage = UIImage(cgImage: cgimage)

    guard let newCgImage = contextImage.cgImage else { return self }

    let contextSize: CGSize = contextImage.size

    //Set to square
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    let cropAspect: CGFloat = to.width / to.height

    var cropWidth: CGFloat = to.width
    var cropHeight: CGFloat = to.height

    if to.width > to.height { //Landscape
        cropWidth = contextSize.width
        cropHeight = contextSize.width / cropAspect
        posY = (contextSize.height - cropHeight) / 2
    } else if to.width < to.height { //Portrait
        cropHeight = contextSize.height
        cropWidth = contextSize.height * cropAspect
        posX = (contextSize.width - cropWidth) / 2
    } else { //Square
        if contextSize.width >= contextSize.height { //Square on landscape (or square)
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        }else{ //Square on portrait
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        }
    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

    // Create bitmap image from context using the rect
    guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

    // Create a new image based on the imageRef and rotate back to the original orientation
    let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

    UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
    cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
    let resized = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resized ?? self
  }
}
