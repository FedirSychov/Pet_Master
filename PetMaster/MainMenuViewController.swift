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
    @IBOutlet weak var moneyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insetsLayoutMarginsFromSafeArea = false
        navigationController?.navigationBar.prefersLargeTitles = true
        Design.setupBackground(controller: self)
        Design.SetupBaseButton(button: myAnimalsButton)
        Design.SetupBaseButton(button: settingsButton)
        Design.SetupBaseButton(button: moneyButton)
        moneyButton.setTitle(NSLocalizedString("money_expenditures", comment: ""), for: .normal)
        if !AppVersion.isFullVersion {
            Design.setupDeactivatedButton(button: moneyButton)
            self.moneyButton.isEnabled = false
            self.moneyButton.setTitle("\(NSLocalizedString("money_expenditures", comment: "")) (full version)", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSettings" {
            if let settingsVC = segue.destination as? SettingsTableViewController {
                settingsVC.updatedelegate = self
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
