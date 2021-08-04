//
//  AddEventViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 04.08.2021.
//

import UIKit

class AddEventViewController: UIViewController {

    var currentAnimal: Animal?
    
    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var DateSwitch: UISwitch!
    @IBOutlet weak var EventDescription: UITextField!
    
    @IBAction func DateSwitched(_ sender: UISwitch) {
        if DateSwitch.isOn {
            DatePicker.isEnabled = false
        } else {
            DatePicker.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DateSwitch.isOn {
            DatePicker.isEnabled = false
        } else {
            DatePicker.isEnabled = true
        }
        
    }
    @IBAction func SaveEvent(_ sender: Any) {
        if (EventName.text != ""){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateTxt = ""
        if DateSwitch.isOn {
            dateTxt = dateFormatter.string(from: Date())
        } else{
            dateTxt = dateFormatter.string(from: DatePicker.date)
        }

            var num: Int = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == currentAnimal!.showInfo(){
                    
                    currentAnimal!.add_event(event_name: EventName.text!, event_date: dateTxt, event_descrtiption: EventDescription.text)
                    
                    Saved.shared.currentSaves.animals[num] = currentAnimal!
                    print("AllIsOK")
                    print(Saved.shared.currentSaves.animals[num].events_list.count)
                }
                num += 1
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
