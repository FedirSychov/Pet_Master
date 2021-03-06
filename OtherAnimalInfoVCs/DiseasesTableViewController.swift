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
    var lastVC: UIViewController?
    
    weak var updateDelegate: UpdateStatusDelegate?
    
    var data: [Disease] = []
    @IBOutlet weak var AddButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackgroundForTableView(tableView: self.tableView)
        if currentAnimal!.date_of_death != nil{
            self.AddButton.isEnabled = false
        }
        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal == currentAnimal!{
                self.data = animal.disease_list
            }
            num += 1
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddDisease":
            if let AddDiseaseVC = segue.destination as? AddDiseaseViewController{
                AddDiseaseVC.currentAnimal = self.currentAnimal!
                AddDiseaseVC.addDelegate = self
                AddDiseaseVC.returnDelegate = self.lastVC! as? BackToAnimalDelegate
            }
        case "goToDiseaseInfo":
            if let infoD = segue.destination as? DiseaseInfoViewController{
                infoD.currentAnimal = self.currentAnimal!
                infoD.currentDisease = self.curreentDisease!
                infoD.lastVC = self.lastVC!
                infoD.deleteDelegate = self
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
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: 24)
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        let num: Int = indexPath.row
        self.curreentDisease = data[num]
        return indexPath
    }
}
