//
//  FoodTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 04.08.2021.
//

import UIKit

class FoodTableViewController: UITableViewController {

    var currentAnimal: Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
