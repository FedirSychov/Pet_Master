//
//  VaccInfoViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 05.08.2021.
//

import UIKit

protocol DeleteVaccinationDelegate: NSObject {
    func DeleteVaccination(_ animal: Animal)
}

class VaccInfoViewController: UIViewController {

    var currentVaccination: Vaccination?
    var currentAnimal: Animal?
    
    weak var deleteDelegate: DeleteVaccinationDelegate?
    
    var lastVC: UITableViewController?
    var thisVC: UITableViewController?
    
    var num_animal: Int = 0
    var num_vacc: Int = 0
    
    @IBOutlet weak var optionButton: UIBarButtonItem!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    @IBAction func OptionButton(_ sender: Any) {
        ShowAlertActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupBackground(controller: self)
        DescriptionLabel.sizeToFit()
        if currentAnimal!.date_of_death != nil{
            self.optionButton.isEnabled = false
        }
        reloadInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditVacc"{
            if let editVaccVC = segue.destination as? AddVaccinationViewController{
                editVaccVC.currentVaccination = self.currentVaccination!
                editVaccVC.currentAnimal = self.currentAnimal!
                editVaccVC.lastVC = self.lastVC!
                editVaccVC.thisVC = self.thisVC!
                editVaccVC.editDelegate = self
            }
        }
    }
    
    func reloadInfo(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Saved.shared.currentSettings.dateFormat
        self.NameLabel.text = "\(NSLocalizedString("animal_name", comment: ""))\(currentVaccination!.name)"
        self.DateLabel.text = "\(NSLocalizedString("animal_date", comment: ""))\(dateFormatter.string(from: currentVaccination!.date))"
        self.DescriptionLabel.text = "\(NSLocalizedString("animal_description", comment: ""))\(currentVaccination!.description!)"
    }
    
    private func ShowAlertActionSheet(){
        let alert = UIAlertController(title: NSLocalizedString("options", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: NSLocalizedString("edit", comment: ""), style: .default) { [weak self](_) in
            
            self?.performSegue(withIdentifier: "goToEditVacc", sender: nil)
        }
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive) { [weak self](_) in
            self?.showAlert()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: NSLocalizedString("are_you_sure", comment: ""), message: nil, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default, handler: nil)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .destructive) { [weak self](_) in
            
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self!.currentAnimal!.showInfo(){
                    for vacc in animal.vaccinations_list{
                        if vacc == self!.currentVaccination{
                            
                            let temp1: Animal = Saved.shared.currentSaves.animals[self!.num_animal]
                            temp1.vaccinations_list.remove(at: self!.num_vacc)
                            
                            Saved.shared.currentSaves.animals.remove(at: self!.num_animal)
                            Saved.shared.currentSaves.animals.insert(temp1, at: self!.num_animal)
                            
                            self!.deleteDelegate?.DeleteVaccination(temp1)
                        }
                        self!.num_vacc += 1
                    }
                }
                self!.num_animal += 1
            }
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

extension VaccinationsTableViewController: DeleteVaccinationDelegate {
    func DeleteVaccination(_ animal: Animal) {
        self.dismiss(animated: true) {
            self.currentAnimal = animal
            self.data = animal.vaccinations_list
            self.viewWillAppear(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
