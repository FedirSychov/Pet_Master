//
//  AddVaccinationViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 03.08.2021.
//

import UIKit

class AddVaccinationViewController: UIViewController {

    @IBOutlet weak var VaccName: UITextField!
    @IBOutlet weak var VaccDescription: UITextField!
    @IBOutlet weak var VaccDate: UIDatePicker!
    @IBOutlet weak var DateSwitcher: UISwitch!
    
    var lastVC: UITableViewController?
    
    var currentAnimal: Animal?
    var currentVaccination: Vaccination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.currentVaccination != nil {
            self.VaccName.text = self.currentVaccination!.name
            self.VaccDescription.text = self.currentVaccination!.description
            self.VaccDate.isEnabled = true
            self.DateSwitcher.isOn = false
            self.VaccDate.date = self.currentVaccination!.date
        }
    }
    
    @IBAction func SwitchedDate(_ sender: UISwitch) {
        if DateSwitcher.isOn{
            VaccDate.isEnabled = false
        } else {
            VaccDate.isEnabled = true
        }
    }
    
    @IBAction func SaveVaccination(_ sender: Any) {
        if self.currentVaccination != nil{
            var num_animal: Int = 0
            var num_vacc: Int = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self.currentAnimal!.showInfo(){
                    for vacc in animal.vaccinations_list{
                        if vacc.name == self.currentVaccination!.name && vacc.date == self.currentVaccination!.date{
                            
                            self.currentVaccination!.name = self.VaccName.text!
                            self.currentVaccination!.date = self.VaccDate.date
                            self.currentVaccination!.description = self.VaccDescription.text!
                            
                            let temp: Animal = self.currentAnimal!
                            temp.vaccinations_list[num_vacc] = self.currentVaccination!
                            Saved.shared.currentSaves.animals.remove(at: num_animal)
                            Saved.shared.currentSaves.animals.insert(temp, at: num_animal)
                            
                            self.navigationController?.popToViewController(self.lastVC!, animated: true)
                        }
                        num_vacc += 1
                    }
                }
                num_animal += 1
            }
        } else {
            if (VaccName.text != ""){
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
            var dateTxt = ""
            if DateSwitcher.isOn {
                dateTxt = dateFormatter.string(from: Date())
            } else{
                dateTxt = dateFormatter.string(from: VaccDate.date)
            }

                var num: Int = 0
                for animal in Saved.shared.currentSaves.animals{
                    if animal.showInfo() == currentAnimal!.showInfo(){
                        
                        currentAnimal?.add_vaccination(vacc_name: VaccName.text!, vac_date: dateTxt, description: VaccDescription.text)
                        
                        Saved.shared.currentSaves.animals[num] = currentAnimal!
                        print("AllIsOK")
                        print(Saved.shared.currentSaves.animals[num].vaccinations_list.count)
                    }
                    num += 1
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
}
