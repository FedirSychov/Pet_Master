//
//  AnimalViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalViewController: UIViewController {

    var name: String = ""
    var breed: String = ""
    
    @IBOutlet weak var AnimalImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var BreedLabel: UILabel!
    @IBOutlet weak var Container_table: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for animal in Saved.shared.currentSaves.animals{
            if self.name == animal.name
                //&& self.breed == animal.animal_breed
            {
                NameLabel.text = "Name: \(animal.name)"
                AgeLabel.text = "Age: \(animal.animal_age)"
                TypeLabel.text = "Type: \(animal.animal_type)"
                BreedLabel.text = "Breed: \(animal.animal_breed!)"
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

}
