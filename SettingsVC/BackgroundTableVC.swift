//
//  BackgroundTableVC.swift
//  PetMaster
//
//  Created by Fedor Sychev on 20.08.2021.
//

import UIKit

protocol updateBackgroundDelegate: NSObject {
    func updatebackground()
}

class BackgroundTableVC: UITableViewController {
    
    weak var updateDelegate: updateBackgroundDelegate?
    var mainMenuVC: UIViewController?

    @IBOutlet weak var back1Image: UIImageView!
    @IBOutlet weak var back2Image: UIImageView!
    @IBOutlet weak var back3Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        setupView()
    }
    
    private func setupView() {
        Design.setupBackground(controller: self)
        Design.setupViewBehindTable(tableView: self.tableView)
        back1Image.transform = back1Image.transform.rotated(by: .pi/2)
        back2Image.transform = back2Image.transform.rotated(by: .pi/2)
        back3Image.transform = back3Image.transform.rotated(by: .pi/2)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            Saved.shared.currentSettings.backgroundImage = "Background1"
            Saved.shared.currentSettings.headerColor_red = 255
            Saved.shared.currentSettings.headerColor_green = 159
            Saved.shared.currentSettings.headerColor_blut = 74
            Saved.shared.currentSettings.cellBackground_red = 233
            Saved.shared.currentSettings.cellBackground_green = 91
            Saved.shared.currentSettings.cellBackground_blue = 19
        case 1:
            Saved.shared.currentSettings.backgroundImage = "Background-4"
            Saved.shared.currentSettings.headerColor_red = 102
            Saved.shared.currentSettings.headerColor_green = 187
            Saved.shared.currentSettings.headerColor_blut = 115
            Saved.shared.currentSettings.cellBackground_red = 42
            Saved.shared.currentSettings.cellBackground_green = 137
            Saved.shared.currentSettings.cellBackground_blue = 57
        case 2:
            Saved.shared.currentSettings.backgroundImage = "Background-5"
            Saved.shared.currentSettings.headerColor_red = 88
            Saved.shared.currentSettings.headerColor_green = 188
            Saved.shared.currentSettings.headerColor_blut = 232
            Saved.shared.currentSettings.cellBackground_red = 33
            Saved.shared.currentSettings.cellBackground_green = 111
            Saved.shared.currentSettings.cellBackground_blue = 145
        default:
            Saved.shared.currentSettings.backgroundImage = "Background1"
            Saved.shared.currentSettings.headerColor_red = 255
            Saved.shared.currentSettings.headerColor_green = 171
            Saved.shared.currentSettings.headerColor_blut = 74
            Saved.shared.currentSettings.cellBackground_red = 233
            Saved.shared.currentSettings.cellBackground_green = 92
            Saved.shared.currentSettings.cellBackground_blue = 19
        }
        self.updateDelegate?.updatebackground()
        self.navigationController?.popToViewController(self.mainMenuVC!, animated: true)
        
    }
}

extension MainMenuViewController: updateBackgroundDelegate {
    func updatebackground() {
        self.viewDidLoad()
    }
}
