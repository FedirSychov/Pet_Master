//
//  MainMenuViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 10.08.2021.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var myAnimalsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupBackground(controller: self)
        Design.SetupBaseButton(button: myAnimalsButton)
        Design.SetupBaseButton(button: settingsButton)
    }

}
