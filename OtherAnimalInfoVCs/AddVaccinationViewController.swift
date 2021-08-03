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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SwitchedDate(_ sender: UISwitch) {
        if DateSwitcher.isOn{
            VaccDate.isEnabled = false
        } else {
            VaccDate.isEnabled = true
        }
    }
    @IBAction func SaveVaccination(_ sender: Any) {
        if DateSwitcher.isOn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateTxt = dateFormatter.string(from: VaccDate.date)
            let newVacc = Vaccination(name: VaccName.text!, descrpit: VaccDescription.text, date: dateTxt)
            
            //TODO: - saving vaccination
        }
    }
}
