//
//  SettingsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 08.08.2021.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var sortTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        sortTypeLabel.text = Saved.shared.currentSettings.sort.rawValue
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }


}
