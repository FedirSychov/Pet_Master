//
//  SettingsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 08.08.2021.
//

import UIKit

protocol updateDelegate: NSObject {
    func updateVersion()
}

class SettingsTableViewController: UITableViewController {
    
    weak var updatedelegate: updateDelegate?
    
    let appIconService = AppIconService()
    
    var mainVC: UIViewController?
    
    weak var updateBackgroundDelegate: updateBackgroundDelegate?

    @IBOutlet weak var sortTypeLabel: UILabel!
    @IBOutlet weak var resetSettingsButton: UIButton!
    @IBOutlet weak var SortingLabel: UILabel!
    @IBOutlet weak var dateFormatLabel: UILabel!
    @IBOutlet weak var formatTypeLabel: UILabel!
    @IBOutlet weak var fullVersionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackground(controller: self)
        resetSettingsButton.setTitle(NSLocalizedString("reset_settings", comment: ""), for: .normal)
        SortingLabel.text = NSLocalizedString("sorting", comment: "")
        fullVersionButton.setTitle(NSLocalizedString("full_version", comment: ""), for: .normal)
        sortTypeLabel.text = Saved.shared.currentSettings.sort.rawValue
        dateFormatLabel.text = NSLocalizedString("date_format", comment: "")
        formatTypeLabel.text = Saved.shared.currentSettings.dateFormat
        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    @IBAction func ResetSettingsButton(_ sender: Any) {
        Saved.shared.reserSettings()
        loadSettings()
        appIconService.changeAppIcon(to: .primaryAppIcon)
        self.updateBackgroundDelegate = self.mainVC! as? updateBackgroundDelegate
        self.updateBackgroundDelegate?.updatebackground()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadSettings()
    }
    
    func loadSettings(){
        if Saved.shared.currentSettings.sort.rawValue == "up" {
            self.sortTypeLabel.text = NSLocalizedString("sorting_up", comment: "")
        } else {
            self.sortTypeLabel.text = NSLocalizedString("sorting_down", comment: "")
        }
        self.formatTypeLabel.text = Saved.shared.currentSettings.dateFormat
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFullVersion()
    }
    
    func isFullVersion() -> Int{
        if AppVersion.isFullVersion == true {
            return 4
        } else {
            return 5
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            if Saved.shared.currentSettings.isShared {
                performSegue(withIdentifier: "goToBackgrounds", sender: nil)
            } else {
                Alert.showShareAlert(on: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToPurchase":
            if let purchaseVC = segue.destination as? PurchaseViewController {
                purchaseVC.madePurchaseDelegate = self
            }
        case "goToBackgrounds":
            if let backsVC = segue.destination as? BackgroundTableVC {
                backsVC.updateDelegate = self.mainVC! as? updateBackgroundDelegate
                backsVC.mainMenuVC = self.mainVC!
            }
        default:
            break
        }
    }
    
    func Share() {
        
        if let name = URL(string: "https://apps.apple.com/ru/app/pets-friend/id1582236816"), !name.absoluteString.isEmpty {
            
            let activityVC = UIActivityViewController(activityItems: ["Check out a new app on App Store!", name], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
            
            activityVC.completionWithItemsHandler = { activity, completed, items, error in
                if completed == true {
                    Saved.shared.currentSettings.isShared = true
                }
            }
        }
    }
    
    @IBAction func Share(_ sender: Any) {
        
        if let name = URL(string: "https://apps.apple.com/ru/app/pets-friend/id1582236816"), !name.absoluteString.isEmpty {
            
            let activityVC = UIActivityViewController(activityItems: ["Check out a new app on App Store!", name], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
            
            activityVC.completionWithItemsHandler = { activity, completed, items, error in
                if completed == true {
                    Saved.shared.currentSettings.isShared = true
                }
            }
        }
    }
    
    @IBAction func BuyFullVersion(_ sender: Any) {
        
    }
}

extension MainMenuViewController: updateDelegate {
    func updateVersion() {
        self.viewDidLoad()
        self.moneyButton.isEnabled = true
    }
}
