//
//  VaccinationsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 03.08.2021.
//

import UIKit

class VaccinationsTableViewController: UITableViewController {

    var currentAnimal: Animal?
    var currentVaccination: Vaccination?
    var data: [Vaccination] = []
    
    var lastVC: UITableViewController?
    @IBOutlet weak var AddButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackgroundForTableView(tableView: self.tableView)
        if currentAnimal!.date_of_death != nil{
            AddButton.isEnabled = false
        }
        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal == currentAnimal!{
                self.data = animal.vaccinations_list
            }
            num += 1
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddVacc":
            if let addVaccVC = segue.destination as? AddVaccinationViewController{
                addVaccVC.currentAnimal = self.currentAnimal!
                addVaccVC.lastVC = self.lastVC!
                addVaccVC.addDelegate = self
            }
        case "goToVaccinationInfo":
            if let vaccInfoVC = segue.destination as? VaccInfoViewController{
                vaccInfoVC.currentVaccination = self.currentVaccination!
                vaccInfoVC.currentAnimal = self.currentAnimal!
                vaccInfoVC.lastVC = self.lastVC
                vaccInfoVC.thisVC = self
                vaccInfoVC.deleteDelegate = self
            }
        default:
            break
        }
    }
    
    func deleteCell(cellNum: Int){
        let indexPath = IndexPath(row: cellNum, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension VaccinationsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimal!.vaccinations_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VaccinationCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: 24)
        cell.backgroundColor = .clear
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        let num: Int = indexPath.row
        self.currentVaccination = data[num]
        return indexPath
    }
}
