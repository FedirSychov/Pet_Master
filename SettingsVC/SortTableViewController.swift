//
//  SortTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 08.08.2021.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackground(controller: self)
        setupButtons()
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupButtons(){
        self.downLabel.text = NSLocalizedString("sorting_down", comment: "")
        self.upLabel.text = NSLocalizedString("sorting_up", comment: "")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            Saved.shared.currentSettings.sort = .down
        } else {
            Saved.shared.currentSettings.sort = .up
        }
        self.navigationController?.popViewController(animated: true)
    }
}
