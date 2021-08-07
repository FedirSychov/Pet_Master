//
//  AnimalViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalViewController: UIViewController {
    
    var currentAnimal: Animal?
    
    var lastVC: UITableViewController?
    
    @IBOutlet weak var AnimalImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var BreedLabel: UILabel!
    @IBOutlet weak var Container_table: UIView!
    @IBOutlet weak var Options: UIBarButtonItem!
    
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
    
    func reloadData(){
        NameLabel.text = "Name: \(currentAnimal!.name)"
        AgeLabel.text = "Age: \(currentAnimal!.animal_age)"
        TypeLabel.text = "Type: \(currentAnimal!.animal_type)"
        BreedLabel.text = "Breed: \(currentAnimal!.animal_breed!)"
    }
    
    @IBAction func OptionsButton(_ sender: Any) {
        self.ShowAlertActionSheet()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToVaccinations":
            if let vaccVC = segue.destination as? VaccinationsTableViewController{
                vaccVC.currentAnimal = self.currentAnimal
                vaccVC.lastVC = self.lastVC!
            }
        case "goToDiseasesVC":
            if let vaccVC = segue.destination as? DiseasesTableViewController{
                vaccVC.currentAnimal = self.currentAnimal
            }
        case "goToEventsVC":
            if let eventVC = segue.destination as? EventsTableViewController{
                eventVC.currentAnimal = self.currentAnimal
            }
        case "goToFoodVC":
            if let foodVC = segue.destination as? FoodTableViewController{
                foodVC.currentAnimal = self.currentAnimal
            }
        case "EditAnimal":
            if let navVC = segue.destination as? UINavigationController, let editVC = navVC.topViewController as? AddAnimalViewController{
                editVC.currentAnimal = self.currentAnimal
                editVC.editdelegate = self
            }
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    private func ShowAlertActionSheet(){
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "EditAnimal", sender: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self](_) in
            self?.showAlert()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self](_) in
            var num = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self!.currentAnimal!.showInfo(){
                    Saved.shared.currentSaves.animals.remove(at: num)
                }
                num += 1
            }
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
}
