//
//  AddDiseaseViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 03.08.2021.
//

import UIKit

class AddDiseaseViewController: UIViewController {
    
    var lastVC: UITableViewController?
    var thisVC: UIViewController?

    @IBOutlet weak var DiseaseName: UITextField!
    @IBOutlet weak var StartDateSwitch: UISwitch!
    @IBOutlet weak var EndDateSwitch: UISwitch!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var DiseaseDescription: UITextField!
    @IBOutlet weak var DiseaseMedicines: UITextField!
    @IBOutlet weak var LastsSwitch: UISwitch!
    @IBOutlet weak var EndNowlabel: UILabel!
    
    var currentAnimal: Animal?
    var curreentDisease: Disease?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartDatePicker.maximumDate = Date()
        EndDatePicker.maximumDate = Date()
        if StartDateSwitch.isOn{
            EndDateSwitch.isOn = false
            StartDatePicker.isEnabled = false
            EndDatePicker.isEnabled = false
        }
        if LastsSwitch.isOn{
            EndDatePicker.isEnabled = false
            EndNowlabel.isHidden = true
            EndDateSwitch.isHidden = true
        }
        
        if curreentDisease != nil{
            self.EndDateSwitch.isHidden = false
            self.EndNowlabel.isHidden = false
            self.StartDateSwitch.isOn = false
            self.StartDatePicker.isEnabled = true
            self.EndDateSwitch.isOn = false
            self.EndDatePicker.isEnabled = true
            self.DiseaseName.text = self.curreentDisease!.name
            self.StartDatePicker.date = self.curreentDisease!.data_of_disease
            if self.curreentDisease!.date_of_end != nil{
                self.EndDatePicker.date = self.curreentDisease!.date_of_end!
                self.LastsSwitch.isOn = false
            } else {
                self.LastsSwitch.isOn = true
                self.EndDatePicker.isEnabled = false
                EndDateSwitch.isHidden = true
                EndNowlabel.isHidden = true
            }
            self.DiseaseDescription.text = self.curreentDisease!.description
            self.DiseaseMedicines.text = self.curreentDisease!.medicines
        }

    }
    
    @IBAction func StartSwitched(_ sender: UISwitch) {
        if StartDateSwitch.isOn{
            StartDatePicker.isEnabled = false
            EndDateSwitch.isOn = false
            EndDatePicker.isEnabled = false
        } else {
            StartDatePicker.isEnabled = true
            if EndDateSwitch.isOn{
            } else {
                if LastsSwitch.isOn{
                } else {
                    EndDatePicker.isEnabled = true
                }
            }
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
    
    @IBAction func LastssSwitch(_ sender: Any) {
        if LastsSwitch.isOn{
            EndDatePicker.isEnabled = false
            EndNowlabel.isHidden = true
            EndDateSwitch.isHidden = true
        } else {
            EndDatePicker.isEnabled = true
            EndNowlabel.isHidden = false
            EndDateSwitch.isHidden = false
        }
    }
    
    private func noSameDiaseses(thisD: Disease) -> Bool {
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal == currentAnimal!{
                for disease in Saved.shared.currentSaves.animals[num].disease_list{
                    if thisD == disease{
                        print("I Found!!!")
                        return false
                    }
                }
            }
            num += 1
        }
        return true
    }
    
    @IBAction func SaveDisease(_ sender: Any) {
        if self.curreentDisease != nil{
            var num_animal: Int = 0
            var num_vacc: Int = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self.currentAnimal!.showInfo(){
                    for disease in animal.disease_list{
                        if disease == self.curreentDisease!{
                            
                            let tempDisease: Disease = Saved.shared.currentSaves.animals[num_animal].disease_list[num_vacc]
                            
                            tempDisease.name = self.DiseaseName.text!
                            tempDisease.data_of_disease = self.StartDatePicker.date
                            if LastsSwitch.isOn{
                                tempDisease.date_of_end = nil
                            } else {
                                if EndDateSwitch.isOn{
                                    tempDisease.date_of_end = Date()
                                } else {
                                    tempDisease.date_of_end = self.EndDatePicker.date
                                }
                            }
                            tempDisease.description = self.DiseaseDescription.text!
                            tempDisease.medicines = self.DiseaseMedicines.text!
                            tempDisease.reloadDays()
                            
                            if noSameDiaseses(thisD: tempDisease){
                                if self.DiseaseName.text == ""{
                                    ShowAlertNoData()
                                } else {
                                    let temp: Animal = self.currentAnimal!
                                    temp.disease_list[num_vacc] = tempDisease
                                    if Saved.shared.currentSettings.sort == .down{
                                        temp.disease_list.sort(by: {$0.data_of_disease > $1.data_of_disease})
                                    } else {
                                        temp.disease_list.sort(by: {$0.data_of_disease < $1.data_of_disease})
                                    }
                                    Saved.shared.currentSaves.animals.remove(at: num_animal)
                                    Saved.shared.currentSaves.animals.insert(temp, at: num_animal)
                                    self.navigationController?.popToViewController(thisVC!, animated: true)
                                    break
                                }
                            } else {
                                ShowAlertSameDisease()
                                self.DiseaseName.text = curreentDisease!.name
                                self.StartDatePicker.date = curreentDisease!.data_of_disease
                                break
                            }
                            
                        }
                        num_vacc += 1
                    }
                }
                num_animal += 1
            }
        } else {
            if DiseaseName.text != ""{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                
                var dateOfStart: String = ""
                var dateOfEnd: String? = ""
                
                if StartDateSwitch.isOn{
                    dateOfStart = dateFormatter.string(from: Date())
                } else {
                    dateOfStart = dateFormatter.string(from: StartDatePicker.date)
                }
                if LastsSwitch.isOn{
                    dateOfEnd = nil
                } else {
                    if EndDateSwitch.isOn{
                        dateOfEnd = dateFormatter.string(from: Date())
                    } else {
                        dateOfEnd = dateFormatter.string(from: EndDatePicker.date)
                    }
                }
                
                var num: Int = 0
                for animal in Saved.shared.currentSaves.animals{
                    if animal.showInfo() == currentAnimal!.showInfo(){
                        var newDisease: Disease
                        if LastsSwitch.isOn{
                            newDisease = Disease(name: DiseaseName.text!, data_d: dateOfStart, description: DiseaseDescription.text!, meds: DiseaseMedicines.text!)
                            
                        } else {
                            newDisease = Disease(name: DiseaseName.text!, data_d: dateOfStart, date_end: dateOfEnd, description: DiseaseDescription.text!, meds: DiseaseMedicines.text!)
                        }
                        if noSameDiaseses(thisD: newDisease){
                            currentAnimal!.disease_list.append(newDisease)
                            if Saved.shared.currentSettings.sort == .down{
                                currentAnimal!.disease_list.sort(by: {$0.data_of_disease > $1.data_of_disease})
                            } else {
                                currentAnimal!.disease_list.sort(by: {$0.data_of_disease < $1.data_of_disease})
                            }
                            Saved.shared.currentSaves.animals[num] = currentAnimal!
                            if LastsSwitch.isOn{
                                self.navigationController?.popToViewController(self.lastVC!, animated: true)
                            } else {
                                navigationController?.popViewController(animated: true)
                            }
                        } else {
                            ShowAlertSameDisease()
                        }
                        
                    }
                    num += 1
                }
                
            } else {
                ShowAlertNoData()
            }
        }
    }
    
    private func ShowAlertSameDisease(){
        Alert.showBasicAlert(on: self, with: "Warning", message: "This disease already exists!")
    }
    
    private func ShowAlertNoData(){
        Alert.showIncompleteFormAlert(on: self)
    }
}
