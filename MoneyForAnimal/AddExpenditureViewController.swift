//
//  AddExpenditureViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 14.08.2021.
//

import UIKit

protocol addExpDelegate: NSObject {
    func AddExp(exp: Expenditure)
}

class AddExpenditureViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var gData: [Animal]?
    var currentAnimal: String?
    var currentFor: String?
    var currentForNum: Int?
    
    weak var addDelegate: addExpDelegate?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.animalPicker {
            return getAnimalArray().count
        } else {
            return getForArray().count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.animalPicker {
            return getAnimalArray()[row]
        } else {
            return getForArray()[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.animalPicker {
            self.currentAnimal = getAnimalArray()[row]
        } else {
            self.currentFor = getForArray()[row]
            self.currentForNum = row
        }
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var animalPicker: UIPickerView!
    @IBOutlet weak var forPicker: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.delegate = self
        setupPickers()
        setupView()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupView() {
        nameLabel.text = NSLocalizedString("name", comment: "")
        priceLabel.text = NSLocalizedString("price", comment: "")
        Design.setupBackground(controller: self)
        Design.setupTextField_Type2(field: nameTextField)
        Design.setupTextField_Type2(field: priceTextField)
        Design.SetupBaseButton(button: addButton)
        addButton.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        
        let constraints = [
            animalPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            animalPicker.rightAnchor.constraint(equalTo: self.view.centerXAnchor),
            forPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            animalPicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: animalPicker.bottomAnchor, constant: 45)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPickers() {
        animalPicker.delegate = self
        animalPicker.dataSource = self
        
        animalPicker.layer.borderColor = CGColor(red: CGFloat(Saved.shared.currentSettings.cellBackground_red/255), green: CGFloat(Saved.shared.currentSettings.cellBackground_green/255), blue: CGFloat(Saved.shared.currentSettings.cellBackground_blue/255), alpha: 1)
        animalPicker.layer.borderWidth = 7
        
        forPicker.delegate = self
        forPicker.dataSource = self
        
        forPicker.layer.borderColor = CGColor(red: CGFloat(Saved.shared.currentSettings.cellBackground_red/255), green: CGFloat(Saved.shared.currentSettings.cellBackground_green/255), blue: CGFloat(Saved.shared.currentSettings.cellBackground_blue/255), alpha: 1)
        forPicker.layer.borderWidth = 7
    }
    
    func getAnimalArray() -> [String] {
        self.gData = Saved.shared.currentSaves.animals
        var output: [String] = []
        let data = Saved.shared.currentSaves.animals
        for animal in data {
            output.append(animal.name)
        }
        if output.count == 0 {
            Alert.showBasicAlert(on: self, with: "Warning!", message: "No pets to add expenses")
            dismiss(animated: true, completion: nil)
        } else {
            self.currentAnimal = output[0]
        }
        return output
    }
    
    func getForArray() -> [String] {
        var output: [String] = []
        output.append(NSLocalizedString(moneyFor.entertainment.rawValue, comment: ""))
        output.append(NSLocalizedString(moneyFor.food.rawValue, comment: ""))
        output.append(NSLocalizedString(moneyFor.vet.rawValue, comment: ""))
        output.append(NSLocalizedString(moneyFor.other.rawValue, comment: ""))
        self.currentFor = output[0]
        self.currentForNum = 0
        return output
    }
    
    @IBAction func AddExpenditure(_ sender: Any) {
        
        let tempArr = [moneyFor.entertainment.rawValue, moneyFor.food.rawValue, moneyFor.vet.rawValue, moneyFor.other.rawValue]
        
        if nameTextField.text != "" && priceTextField.text != "" {
            
            let newExp = Expenditure(name: nameTextField.text!, animal: currentAnimal!, summ: Double(priceTextField.text!)!, forM: moneyFor(rawValue: tempArr[self.currentForNum!])!)
            self.addDelegate?.AddExp(exp: newExp)
        } else {
            ShowAlertNoData()
        }
    }
    
    private func ShowAlertNoData(){
        Alert.showBasicAlert(on: self, with: "Warning!", message: "Please fill out all fields!")
    }
}

extension AddExpenditureViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newCharacters = NSCharacterSet(charactersIn: string)
        let boolIsNumber = NSCharacterSet.decimalDigits.isSuperset(of: newCharacters as CharacterSet)
            if boolIsNumber == true {
                return true
            } else {
                if string == "." {
                    let countdots = textField.text!.components(separatedBy: ".").count - 1
                    if countdots == 0 {
                        return true
                    } else {
                        if countdots > 0 && string == "." {
                            return false
                        } else {
                            return true
                        }
                    }
                } else {
                    return false
                }
            }
    }
}

extension MoneyViewController: addExpDelegate {
    func AddExp(exp: Expenditure) {
        dismiss(animated: true) {
            var temp = Saved.shared.currentExpenditures.allExpenditures
            temp.append(exp)
            Saved.shared.currentExpenditures.allExpenditures = temp
            self.countMoney()
        }
    }
}
