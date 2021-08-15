//
//  AnimalsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalsTableViewController: UITableViewController {

    var data:[Animal] = []
    var currentAnimal: Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackground(controller: self)
        tableView.register(AnimalTableViewCell.nib(), forCellReuseIdentifier: AnimalTableViewCell.identifier)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        data = Saved.shared.currentSaves.animals
        self.tableView.reloadData()
    }
// MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goToAnimalInfo":
            
            if let vc = segue.destination as? AnimalViewController{
                vc.currentAnimal = self.currentAnimal
                vc.lastVC = self
            }
        case "addNewAnimal":
            if let navVC = segue.destination as? UINavigationController, let newVC = navVC.topViewController as? AddAnimalViewController{
                newVC.delegate = self
            }
        default:
            break
        }
    }
    
    
}
//MARK: - TableView
extension AnimalsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Saved.shared.currentSaves.animals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.identifier, for: indexPath) as! AnimalTableViewCell
        cell.configure(with: data[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentAnimal = data[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToAnimalInfo", sender: nil)
        return indexPath
    }
}
