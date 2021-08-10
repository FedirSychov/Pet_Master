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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateOfBirth.maximumDate = Date()
    
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
            //print(num)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.currentAnimal = nil
        self.num = 0
    }
    
    @IBAction func AddAnimalButton(_ sender: Any) {
        //TODO: - Add checking for alredy existed animals
        if currentAnimal != nil{
            Saved.shared.currentSaves.animals.remove(at: num)
            
            currentAnimal?.name = NameTextField.text!
            currentAnimal?.animal_type = TypeTextField.text!
            currentAnimal?.date_of_birth = DateOfBirth.date
            currentAnimal?.animal_breed = breedTextField.text!
            
            Saved.shared.currentSaves.animals.insert(currentAnimal!, at: num)
            
            editdelegate?.UpdateAnimal(currentAnimal!)
            //TODO: - go back and reload animal info
        } else {
            if (NameTextField.text != "" && TypeTextField.text != "" && breedTextField.text != "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateTxt = dateFormatter.string(from: DateOfBirth.date)
            let newAnimal = Animal(name: NameTextField.text!, birthday: dateTxt, type: TypeTextField.text!, breed: breedTextField.text!)
            Saved.shared.currentSaves.animals.append(newAnimal)
            
                delegate?.AddNew(newAnimal)
            }
        }
    }
}

extension AnimalsTableViewController: AnimalsDelegate{
    func AddNew(_ animal: Animal) {
        dismiss(animated: true) { [weak self] in
            self?.data.append(animal)
            self?.tableView.reloadData()
        }
    }
}

extension AnimalViewController: UpdateDelegate{
    func UpdateAnimal(_ animal: Animal) {
        dismiss(animated: true) { [weak self] in
            self?.currentAnimal = animal
            self?.reloadData()
            print("2 is OK")
        }
    }
}
