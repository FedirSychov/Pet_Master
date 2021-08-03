//
//  AnimalsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalsTableViewController: UITableViewController {

    var data:[Animal] = []
    
    var chosenName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        data = Saved.shared.currentSaves.animals
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goToAnimalInfo":
            
            if let vc = segue.destination as? AnimalViewController{
                vc.name = chosenName
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

extension AnimalsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Saved.shared.currentSaves.animals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }

    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        chosenName = data[indexPath.row].name
        
        tableView.deselectRow(at: indexPath, animated: true)
        return indexPath
    }
}
