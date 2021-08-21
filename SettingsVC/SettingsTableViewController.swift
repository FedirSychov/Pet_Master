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
    
    var mainVC: UIViewController?

    @IBOutlet weak var sortTypeLabel: UILabel!
    @IBOutlet weak var resetSettingsButton: UIButton!
    @IBOutlet weak var SortingLabel: UILabel!
    @IBOutlet weak var dateFormatLabel: UILabel!
    @IBOutlet weak var formatTypeLabel: UILabel!
    @IBOutlet weak var fullVersionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Saved.shared.currentSettings.isShared = false
        print("GAY--------", Saved.shared.currentSettings.isShared)
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
        let activityVC = UIActivityViewController(activityItems: ["Check out a new app! "], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            if completed == true {
                Saved.shared.currentSettings.isShared = true
            }
        }
    }
    
    @IBAction func Share(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Check out a new app! "], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            if completed == true {
                Saved.shared.currentSettings.isShared = true
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
