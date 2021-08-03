//
//  AddDiseaseViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 03.08.2021.
//

import UIKit

class AddDiseaseViewController: UIViewController {
    

    @IBOutlet weak var DiseaseName: UITextField!
    @IBOutlet weak var StartDateSwitch: UISwitch!
    @IBOutlet weak var EndDateSwitch: UISwitch!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var DiseaseDescription: UITextField!
    @IBOutlet weak var DiseaseMedicines: UITextField!
    
    var currentAnimal: Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if StartDateSwitch.isOn{
            EndDateSwitch.isOn = false
            StartDatePicker.isEnabled = false
        }

    }
    
    @IBAction func StartSwitched(_ sender: UISwitch) {
        if StartDateSwitch.isOn{
            StartDatePicker.isEnabled = false
            EndDateSwitch.isOn = false
            EndDatePicker.isEnabled = true
        } else {
            StartDatePicker.isEnabled = true
        }
    }
    
    @IBAction func EndSwitched(_ sender: UISwitch) {
        if EndDateSwitch.isOn{
            StartDatePicker.isEnabled = true
            StartDateSwitch.isOn = false
            EndDatePicker.isEnabled = false
        } else {
            EndDatePicker.isEnabled = true
        }
    }
    
    @IBAction func SaveDisease(_ sender: Any) {
        if DiseaseName.text != ""{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            var dateOfStart: String = ""
            var dateOfEnd: String = ""
            
            if StartDateSwitch.isOn{
                dateOfStart = dateFormatter.string(from: Date())
            } else {
                dateOfStart = dateFormatter.string(from: StartDatePicker.date)
            }
            
            if EndDateSwitch.isOn{
                dateOfEnd = dateFormatter.string(from: Date())
            } else {
                dateOfEnd = dateFormatter.string(from: EndDatePicker.date)
            }
            
            var num: Int = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == currentAnimal!.showInfo(){
                    
                    if StartDateSwitch.isOn{
                        currentAnimal?.add_disease_no_end(disease_name: DiseaseName.text!, disease_date: dateOfStart, description: DiseaseDescription.text!, meds: DiseaseMedicines.text!)
                    } else {
                    currentAnimal?.add_disease(disease_name: DiseaseName.text!, disease_date: dateOfStart, disease_end: dateOfEnd, description: DiseaseDescription.text!, meds: DiseaseMedicines.text!)
                    }
                    Saved.shared.currentSaves.animals[num] = currentAnimal!
                    print("AllIsOK")
                    print(Saved.shared.currentSaves.animals[num].disease_list.count)
                }
                num += 1
            }
            navigationController?.popViewController(animated: true)
        }
    }
}
