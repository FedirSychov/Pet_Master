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
    
    var currentAnimal: Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SwitchedDate(_ sender: UISwitch) {
        if DateSwitcher.isOn{
            VaccDate.isEnabled = false
        } else {
            VaccDate.isEnabled = true
        }
    }
    @IBAction func SaveVaccination(_ sender: Any) {
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
}
