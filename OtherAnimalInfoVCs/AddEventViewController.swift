//
//  AddEventViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 04.08.2021.
//

import UIKit

protocol AddEventDelegate: NSObject {
    func AddEvent(_ event: Event)
}

protocol EditEventDelegate: NSObject {
    func EditEvent(_ event: Event)
}

class AddEventViewController: UIViewController {
    
    weak var addProtocol: AddEventDelegate?
    weak var editProtocol: EditEventDelegate?

    var currentAnimal: Animal?
    var currentEvent: Event?
    
    var num_animal: Int = 0
    var num_event: Int = 0
    
    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var DateSwitch: UISwitch!
    @IBOutlet weak var EventDescription: UITextField!
    
    @IBOutlet weak var ScrollView: UIScrollView!
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
        Design.setupTextField_Type2(field: EventName)
        DatePicker.layer.borderColor = CGColor(red: CGFloat(Saved.shared.currentSettings.cellBackground_red/255), green: CGFloat(Saved.shared.currentSettings.cellBackground_green/255), blue: CGFloat(Saved.shared.currentSettings.cellBackground_blue/255), alpha: 1)
        DatePicker.layer.borderWidth = 7
        Design.setupTextField_Type2(field: EventDescription)
        nameLabel.text = NSLocalizedString("name", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        todayLabel.text = NSLocalizedString("today", comment: "")
        descriptionLabel.text = NSLocalizedString("description", comment: "")
    }
    
    private func setupConstraints() {
        self.ScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        self.ScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.ScrollView.topAnchor, constant: 40).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        self.hideKeyboardWhenTappedAround()
        
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
                            let tempEvent: Event = Saved.shared.currentSaves.animals[num_animal].events_list[num_event]
                            
                            tempEvent.name = self.EventName.text!
                            if DateSwitch.isOn {
                                tempEvent.date = Date()
                            } else {
                                tempEvent.date = self.DatePicker.date
                            }
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
                    
                                    editProtocol?.EditEvent(tempEvent)
                                }
                            } else {
                                ShowAlertSameEvent()
                                EventName.text = currentEvent!.name
                                DatePicker.date = currentEvent!.date
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
                            addProtocol?.AddEvent(tempEvent)
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

extension EventsTableViewController: AddEventDelegate {
    func AddEvent(_ event: Event) {
        dismiss(animated: true) {
            self.viewWillAppear(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EventInfoViewController: EditEventDelegate {
    func EditEvent(_ event: Event) {
        dismiss(animated: true) {
            self.currentEvent = event
            self.reloadInfo()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
