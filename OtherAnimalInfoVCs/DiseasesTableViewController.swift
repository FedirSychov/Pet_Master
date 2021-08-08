//
//  DiseasesTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 03.08.2021.
//

import UIKit

class DiseasesTableViewController: UITableViewController {

    var currentAnimal: Animal?
    var curreentDisease: Disease?
    var lastVC: UITableViewController?
    //var animalVC: UIViewController?
    var data: [Disease] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        data = currentAnimal!.disease_list
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddDisease":
            if let AddDiseaseVC = segue.destination as? AddDiseaseViewController{
                AddDiseaseVC.currentAnimal = self.currentAnimal!
                AddDiseaseVC.lastVC = self.lastVC!
            }
        case "goToDiseaseInfo":
            if let infoD = segue.destination as? DiseaseInfoViewController{
                infoD.currentAnimal = self.currentAnimal!
                infoD.currentDisease = self.curreentDisease!
                infoD.lastVC = self.lastVC!
            }
        default:
            break
        }
    }
}

extension DiseasesTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimal!.disease_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiseaseCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        let num: Int = indexPath.row
        self.curreentDisease = data[num]
        return indexPath
    }
}
