//
//  AnimalViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalViewController: UIViewController {
    
    var currentAnimal: Animal?
    
    @IBOutlet weak var AnimalImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var BreedLabel: UILabel!
    @IBOutlet weak var Container_table: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for animal in Saved.shared.currentSaves.animals{
            if self.currentAnimal?.showInfo() == animal.showInfo()
                //&& self.breed == animal.animal_breed
            {
                currentAnimal = animal
                NameLabel.text = "Name: \(animal.name)"
                AgeLabel.text = "Age: \(animal.animal_age)"
                TypeLabel.text = "Type: \(animal.animal_type)"
                BreedLabel.text = "Breed: \(animal.animal_breed!)"
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToVaccinations":
            if let vaccVC = segue.destination as? VaccinationsTableViewController{
                vaccVC.currentAnimal = self.currentAnimal
            }
            //TODO: - segue for others
        case "goToDiseasesVC":
            if let vaccVC = segue.destination as? DiseasesTableViewController{
                vaccVC.currentAnimal = self.currentAnimal
            }
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

}
