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

class AddAnimalViewController: UIViewController {
    
    weak var delegate: AnimalsDelegate?

    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var TypeTextField: UITextField!
    @IBOutlet weak var DateOfBirth: UIDatePicker!
    @IBOutlet weak var breedTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddAnimalButton(_ sender: Any) {
        //TODO: - Add checking for alredy existed animals
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

extension AnimalsTableViewController: AnimalsDelegate{
    func AddNew(_ animal: Animal) {
        dismiss(animated: true) { [weak self] in
            self?.data.append(animal)
            self?.tableView.reloadData()
        }
    }
    
    
}
