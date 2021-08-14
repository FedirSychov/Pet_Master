//
//  AddAnimalViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

protocol  AnimalsDelegate: NSObject {
    func AddNew(_ animal: Animal)
}

protocol UpdateDelegate: NSObject{
    func UpdateAnimal(_ animal: Animal)
}

class AddAnimalViewController: UIViewController {
    
    var currentAnimal: Animal?
    var num: Int = -1
    
    weak var delegate: AnimalsDelegate?
    weak var editdelegate: UpdateDelegate?

    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var TypeTextField: UITextField!
    @IBOutlet weak var DateOfBirth: UIDatePicker!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupBackground(controller: self)
        DateOfBirth.maximumDate = Date()
        Design.SetupBaseButton(button: SaveButton)
        SaveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        setupButtons()
        if currentAnimal != nil{
            num = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == currentAnimal!.showInfo(){
                    break
                }
                num += 1
            }
            NameTextField.text = currentAnimal?.name
            TypeTextField.text = currentAnimal?.animal_type
            DateOfBirth.date = currentAnimal!.date_of_birth
            breedTextField.text = currentAnimal?.animal_breed
        }
    }
    
    private func setupButtons(){
        Design.setupTextField_Type2(field: NameTextField)
        Design.setupTextField_Type2(field: TypeTextField)
        Design.setupTextField_Type2(field: breedTextField)
        nameLabel.text = NSLocalizedString("name", comment: "")
        typeLabel.text = NSLocalizedString("type", comment: "")
        birthdayLabel.text = NSLocalizedString("birthday", comment: "")
        breedLabel.text = NSLocalizedString("breed", comment: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.currentAnimal = nil
        self.num = 0
    }
    
    private func noSameAnimalsLike(thisAnimal: Animal) -> Bool {
        for animal in Saved.shared.currentSaves.animals{
            if thisAnimal == animal{
                return false
            }
        }
        return true
    }
    
    @IBAction func AddAnimalButton(_ sender: Any) {
        //TODO: - Add checking for alredy existed animals
        if currentAnimal != nil{
            if currentAnimal!.name == NameTextField.text! && currentAnimal!.animal_type == TypeTextField.text! && currentAnimal!.date_of_birth == DateOfBirth.date && currentAnimal!.animal_breed == breedTextField.text!{
                editdelegate?.UpdateAnimal(currentAnimal!)
            } else {
                currentAnimal?.name = NameTextField.text!
                currentAnimal?.animal_type = TypeTextField.text!
                currentAnimal?.date_of_birth = DateOfBirth.date
                currentAnimal?.animal_breed = breedTextField.text!
                if noSameAnimalsLike(thisAnimal: currentAnimal!){
                    Saved.shared.currentSaves.animals.remove(at: num)
                    _ = currentAnimal!.UpdateAge()
                    Saved.shared.currentSaves.animals.insert(currentAnimal!, at: num)
                    editdelegate?.UpdateAnimal(currentAnimal!)
                } else {
                    ShowAlertSameAnimal()
                }
            }
        } else {
            if (NameTextField.text != "" && TypeTextField.text != "" && breedTextField.text != "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateTxt = dateFormatter.string(from: DateOfBirth.date)
            let newAnimal = Animal(name: NameTextField.text!, birthday: dateTxt, type: TypeTextField.text!, breed: breedTextField.text!)
                if noSameAnimalsLike(thisAnimal: newAnimal){
                    _ = newAnimal.UpdateAge()
                    Saved.shared.currentSaves.animals.insert(newAnimal, at: 0)
            
                    delegate?.AddNew(newAnimal)
                } else {
                    ShowAlertSameAnimal()
                }
            } else {
                ShowAlertNoData()
            }
        }
    }
    
    private func ShowAlertSameAnimal(){
        Alert.showBasicAlert(on: self, with: "Warning", message: "This animal already exists!")
    }
    
    private func ShowAlertNoData(){
        Alert.showIncompleteFormAlert(on: self)
    }
}

extension AnimalsTableViewController: AnimalsDelegate{
    func AddNew(_ animal: Animal) {
        dismiss(animated: true) { [weak self] in
            self?.data.insert(animal, at: 0)
            _ = self?.data[0].UpdateAge()
            self?.tableView.reloadData()
        }
    }
}

extension AnimalViewController: UpdateDelegate{
    func UpdateAnimal(_ animal: Animal) {
        dismiss(animated: true) { [weak self] in
            self?.currentAnimal = animal
            self?.reloadData()
        }
    }
}
