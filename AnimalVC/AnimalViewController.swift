//
//  AnimalViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalViewController: UIViewController {
    //TODO: - make updating of disease days
    //TODO: - make list of current diseases
    var currentAnimal: Animal?
    var currentDiseaseLasts: Disease?
    var currDiseaseNum: Int = -1
    
    var lastVC: UITableViewController?
    
    @IBOutlet weak var AnimalImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var AgeLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var BreedLabel: UILabel!
    @IBOutlet weak var Container_table: UIView!
    @IBOutlet weak var Options: UIBarButtonItem!
    @IBOutlet weak var MakeHealthy: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStatus()
    }
    
    func ReloadStatus() {
        var temp1: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal.showInfo() == self.currentAnimal?.showInfo(){
                self.currentAnimal = animal
                StatusLabel.text = "Sick"
                MakeHealthy.isHidden = false
            }
            temp1 += 1
        }
    }
    
    func updateStatus(){
        if currentAnimal!.disease_list.count > 0{
            var temp: Int = 0
            for disease in currentAnimal!.disease_list{
                if disease.date_of_end == nil{
                    currDiseaseNum = temp
                    break
                }
                temp += 1
            }
            if currDiseaseNum != -1{
                StatusLabel.text = "Sick: \(currentAnimal!.disease_list[currDiseaseNum].name)"
                MakeHealthy.isHidden = false
            } else {
                StatusLabel.text = "Healthy"
                MakeHealthy.isHidden = true
            }
            NameLabel.text = "Name: \(currentAnimal!.name)"
            AgeLabel.text = "Age: \(currentAnimal!.animal_age)"
            TypeLabel.text = "Type: \(currentAnimal!.animal_type)"
            BreedLabel.text = "Breed: \(currentAnimal!.animal_breed!)"
        }
        else {
            StatusLabel.text = "Healthy"
            MakeHealthy.isHidden = true
            NameLabel.text = "Name: \(currentAnimal!.name)"
            AgeLabel.text = "Age: \(currentAnimal!.animal_age)"
            TypeLabel.text = "Type: \(currentAnimal!.animal_type)"
            BreedLabel.text = "Breed: \(currentAnimal!.animal_breed!)"
        }
    }
    
    @IBAction func MakeHealthyButton(_ sender: Any) {
        currentAnimal!.disease_list[currDiseaseNum].date_of_end = Date()
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal.showInfo() == currentAnimal!.showInfo(){
                Saved.shared.currentSaves.animals.remove(at: num)
                Saved.shared.currentSaves.animals.insert(currentAnimal!, at: num)
            }
            num += 1
        }
        self.MakeHealthy.isHidden = true
        self.StatusLabel.text = "Healthy"
        currDiseaseNum = -1
        updateStatus()
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
            if let diseaseVC = segue.destination as? DiseasesTableViewController{
                diseaseVC.currentAnimal = self.currentAnimal
                diseaseVC.lastVC = self.lastVC!
                //diseaseVC.animalVC = self
            }
        case "goToEventsVC":
            if let eventVC = segue.destination as? EventsTableViewController{
                eventVC.currentAnimal = self.currentAnimal
                eventVC.lastVC = self.lastVC!
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
