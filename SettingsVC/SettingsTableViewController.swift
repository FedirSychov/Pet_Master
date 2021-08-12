//
//  SettingsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 08.08.2021.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var sortTypeLabel: UILabel!
    @IBOutlet weak var resetSettingsButton: UIButton!
    @IBOutlet weak var SortingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupBackground(controller: self)
        resetSettingsButton.setTitle(NSLocalizedString("reset_settings", comment: ""), for: .normal)
        SortingLabel.text = NSLocalizedString("sorting", comment: "")
        sortTypeLabel.text = Saved.shared.currentSettings.sort.rawValue
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
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
