//
//  SettingsViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var SettingsTableView: UITableView!{
        didSet{
            SettingsTableView?.dataSource = self
            SettingsTableView?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        //Сделать неодинаковые ячейки
        return cell
    }
    
    
}
