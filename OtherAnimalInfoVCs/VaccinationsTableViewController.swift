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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        data = currentAnimal!.vaccinations_list
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddVacc":
            if let addVaccVC = segue.destination as? AddVaccinationViewController{
                addVaccVC.currentAnimal = self.currentAnimal!
            }
        case "goToVaccinationInfo":
            if let vaccInfoVC = segue.destination as? VaccInfoViewController{
                vaccInfoVC.currentVaccination = self.currentVaccination!
            }
        default:
            break
        }
    }
}

extension VaccinationsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimal!.vaccinations_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VaccinationCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        let num: Int = indexPath.row
        self.currentVaccination = data[num]
        return indexPath
    }
}
