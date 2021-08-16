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
        setupPickers()
        setupView()
    }
    
    private func setupView() {
        Design.setupBackground(controller: self)
        Design.setupTextField_Type2(field: nameTextField)
        Design.setupTextField_Type2(field: priceTextField)
        Design.SetupBaseButton(button: addButton)
        
        let constraints = [
            animalPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            animalPicker.rightAnchor.constraint(equalTo: self.view.centerXAnchor),
            forPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            animalPicker.leftAnchor.constraint(equalTo: self.view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: animalPicker.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPickers() {
        animalPicker.delegate = self
        animalPicker.dataSource = self
        
        forPicker.delegate = self
        forPicker.dataSource = self
    }
    
    func getAnimalArray() -> [String] {
        self.gData = Saved.shared.currentSaves.animals
        var output: [String] = []
        let data = Saved.shared.currentSaves.animals
        for animal in data {
            output.append(animal.name)
        }
        self.currentAnimal = output[0]
        return output
    }
    
    func getForArray() -> [String] {
        var output: [String] = []
        output.append(moneyFor.entertainment.rawValue)
        output.append(moneyFor.food.rawValue)
        output.append(moneyFor.vet.rawValue)
        output.append(moneyFor.other.rawValue)
        self.currentFor = output[0]
        return output
    }
    
    @IBAction func AddExpenditure(_ sender: Any) {
        if nameTextField.text != "" && priceTextField.text != "" {
            let newExp = Expenditure(name: nameTextField.text!, animal: currentAnimal!, summ: Double(priceTextField.text!)!, forM: moneyFor(rawValue: currentFor!)!)
            self.addDelegate?.AddExp(exp: newExp)
        } else {
            ShowAlertNoData()
        }
    }
    
    private func ShowAlertNoData(){
        Alert.showBasicAlert(on: self, with: "Warning!", message: "Please fill out all fields!")
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
