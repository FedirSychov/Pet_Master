//
//  DiseaseInfoViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 07.08.2021.
//

import UIKit

class DiseaseInfoViewController: UIViewController {

    var currentDisease: Disease?
    var currentAnimal: Animal?
    
    var lastVC: UITableViewController?
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DaysLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    var num_animal: Int = 0
    var num_disease: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadInfo()
    }
    
    @IBAction func OptionsButton(_ sender: Any) {
        ShowAlertActionSheet()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditDisease"{
            if let editDiseaseVC = segue.destination as? AddDiseaseViewController{
                editDiseaseVC.curreentDisease = self.currentDisease!
                editDiseaseVC.currentAnimal = self.currentAnimal!
                editDiseaseVC.lastVC = self.lastVC!
            }
        }
    }
    
    func reloadInfo(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        self.NameLabel.text = "Name: \(currentDisease!.name)"
        self.DateLabel.text = "Date: \(dateFormatter.string(from: currentDisease!.data_of_disease))"
        self.DescriptionLabel.text = "Description: \(currentDisease!.description)"
        self.DaysLabel.text = "Days last: \(currentDisease!.days_of_disease)"
    }
    
    private func ShowAlertActionSheet(){
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self](_) in
            
            self?.performSegue(withIdentifier: "goToEditDisease", sender: nil)
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
            
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self!.currentAnimal!.showInfo(){
                    for disease in animal.disease_list{
                        if disease == self!.currentDisease{
                            
                            let temp1: Animal = Saved.shared.currentSaves.animals[self!.num_animal]
                            temp1.disease_list.remove(at: self!.num_disease)
                            
                            Saved.shared.currentSaves.animals.remove(at: self!.num_animal)
                            Saved.shared.currentSaves.animals.insert(temp1, at: self!.num_animal)
                            
                            self?.navigationController?.popToViewController((self?.lastVC)!, animated: true)
                        }
                        self!.num_disease += 1
                    }
                }
                self!.num_animal += 1
            }
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
}
