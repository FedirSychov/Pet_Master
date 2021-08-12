//
//  DateFormatTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 12.08.2021.
//

import UIKit

class DateFormatTableViewController: UITableViewController {

    @IBOutlet weak var DMYLabel: UILabel!
    @IBOutlet weak var MDYLabel: UILabel!
    @IBOutlet weak var YDMlabel: UILabel!
    @IBOutlet weak var YMDlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupBackground(controller: self)
        self.tableView.tableFooterView = UIView(frame: .zero)
        setupLabels()
    }
    
    private func setupLabels() {
        DMYLabel.text = NSLocalizedString("day/month/year", comment: "")
        MDYLabel.text = NSLocalizedString("month/day/year", comment: "")
        YDMlabel.text = NSLocalizedString("year/day/month", comment: "")
        YMDlabel.text = NSLocalizedString("year/month/day", comment: "")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenFormat: String
        switch indexPath.row {
        case 0:
            chosenFormat = "dd/MM/YYYY"
        case 1:
            chosenFormat = "MM/dd/YYYY"
        case 2:
            chosenFormat = "YYYY/dd/MM"
        case 3:
            chosenFormat = "YYYY/MM/dd"
        default:
            chosenFormat = "dd/MM/YYYY"
        }
        Saved.shared.currentSettings.dateFormat = chosenFormat
        self.navigationController?.popViewController(animated: true)
    }
}
