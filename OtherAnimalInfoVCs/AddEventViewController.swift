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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func DateSwitched(_ sender: UISwitch) {
        if DateSwitch.isOn {
            DatePicker.isEnabled = false
        } else {
            DatePicker.isEnabled = true
        }
    }
    
    private func setupLabels(){
        nameLabel.text = NSLocalizedString("name", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        todayLabel.text = NSLocalizedString("today", comment: "")
        descriptionLabel.text = NSLocalizedString("description", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        Design.setupBackground(controller: self)
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
    
    private func noSameEvents(thisD: Event) -> Bool {
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal == currentAnimal!{
                for event in Saved.shared.currentSaves.animals[num].events_list{
                    if thisD == event{
                        print("I Found!!!")
                        return false
                    }
                }
            }
            num += 1
        }
        return true
    }
    
    @IBAction func SaveEvent(_ sender: Any) {
        if currentEvent != nil{
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self.currentAnimal!.showInfo(){
                    for event in animal.events_list{
                        if event == self.currentEvent!{
                            print(num_event, num_animal)
                            let tempEvent: Event = Saved.shared.currentSaves.animals[num_animal].events_list[num_event]
                            
                            tempEvent.name = self.EventName.text!
                            tempEvent.date = self.DatePicker.date
                            tempEvent.description = self.EventDescription.text!
                            if noSameEvents(thisD: tempEvent){
                                if EventName.text == ""{
                                    ShowAlertNoData()
                                } else {
                                    let temp: Animal = self.currentAnimal!
                                    temp.events_list[num_event] = tempEvent
                                    if Saved.shared.currentSettings.sort == .down{
                                        temp.events_list.sort(by: {$0.date > $1.date})
                                    } else {
                                        temp.events_list.sort(by: {$0.date < $1.date})
                                    }
                                    Saved.shared.currentSaves.animals.remove(at: num_animal)
                                    Saved.shared.currentSaves.animals.insert(temp, at: num_animal)
                    
                                    self.navigationController?.popToViewController(self.thisVC!, animated: true)
                                }
                            } else {
                                ShowAlertSameEvent()
                                EventName.text = currentEvent!.name
                                DatePicker.date = currentEvent!.date
                                break
                            }
                        }
                        num_event += 1
                    }
                }
                num_animal += 1
            }
            num_animal = 0
            num_event = 0
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
                        let tempEvent = Event(name: EventName.text!, date: dateTxt, descr: EventDescription.text)
                        if noSameEvents(thisD: tempEvent){
                            currentAnimal!.events_list.append(tempEvent)
                            if Saved.shared.currentSettings.sort == .down{
                                currentAnimal!.events_list.sort(by: {$0.date > $1.date})
                            } else {
                                currentAnimal!.events_list.sort(by: {$0.date < $1.date})
                            }
                            Saved.shared.currentSaves.animals[num] = currentAnimal!
                            navigationController?.popViewController(animated: true)
                        } else {
                            ShowAlertSameEvent()
                        }
                        
                    }
                    num += 1
                }
            } else {
                ShowAlertNoData()
            }
        }
    }
    
    private func ShowAlertSameEvent(){
        Alert.showBasicAlert(on: self, with: "Warning", message: "This event already exists!")
    }
    
    private func ShowAlertNoData(){
        Alert.showIncompleteFormAlert(on: self)
    }
}
