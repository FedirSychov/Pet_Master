//
//  AddEventViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 04.08.2021.
//

import UIKit

class AddEventViewController: UIViewController {

    var currentAnimal: Animal?
    var currentEvent: Event?
    var lastVC: UITableViewController?
    var thisVC: UIViewController?
    
    var num_animal: Int = 0
    var num_event: Int = 0
    
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
        DatePicker.maximumDate = Date()
        if DateSwitch.isOn {
            DatePicker.isEnabled = false
        } else {
            DatePicker.isEnabled = true
        }
        if self.currentEvent != nil{
            self.EventName.text = currentEvent!.name
            self.DatePicker.date = currentEvent!.date
            self.DatePicker.isEnabled = true
            self.DateSwitch.isOn = false
            self.EventDescription.text = currentEvent!.description
        }
    }
    
    @IBAction func SaveEvent(_ sender: Any) {
        if currentEvent != nil{
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self.currentAnimal!.showInfo(){
                    for event in animal.events_list{
                        if event == self.currentEvent!{
                            
                            self.currentEvent!.name = self.EventName.text!
                            self.currentEvent!.date = self.DatePicker.date
                            self.currentEvent!.description = self.EventDescription.text!
                            
                            let temp: Animal = self.currentAnimal!
                            temp.events_list[num_event] = self.currentEvent!
                            if Saved.shared.currentSettings.sort == .down{
                                currentAnimal!.events_list.sort(by: {$0.date > $1.date})
                            } else {
                                currentAnimal!.events_list.sort(by: {$0.date < $1.date})
                            }
                            Saved.shared.currentSaves.animals.remove(at: num_animal)
                            Saved.shared.currentSaves.animals.insert(temp, at: num_animal)
            
                            self.navigationController?.popViewController(animated: true)
                            self.thisVC!.viewDidLoad()
                        }
                        num_event += 1
                    }
                }
                num_animal += 1
            }
        } else {
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
                        if Saved.shared.currentSettings.sort == .down{
                            currentAnimal!.events_list.sort(by: {$0.date > $1.date})
                        } else {
                            currentAnimal!.events_list.sort(by: {$0.date < $1.date})
                        }
                        Saved.shared.currentSaves.animals[num] = currentAnimal!
                    }
                    num += 1
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
}
