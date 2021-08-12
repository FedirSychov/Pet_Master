//
//  EventInfoViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 07.08.2021.
//

import UIKit

class EventInfoViewController: UIViewController {

    var currentEvent: Event?
    var currentAnimal: Animal?
    
    var lastVC: UITableViewController?
    var thisVC: UITableViewController?
    
    var num_animal: Int = 0
    var num_event: Int = 0
    
    @IBOutlet weak var optionButton: UIBarButtonItem!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var Descriptionlabel: UILabel!
    
    @IBOutlet weak var OptionsButton: UIBarButtonItem!
    @IBAction func OptionsButtonClick(_ sender: Any) {
        ShowAlertActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Design.setupBackground(controller: self)
        Descriptionlabel.sizeToFit()
        if currentAnimal!.date_of_death != nil{
            self.optionButton.isEnabled = false
        }
        reloadInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditEvent"{
            if let editEventVC = segue.destination as? AddEventViewController{
                editEventVC.currentEvent = self.currentEvent!
                editEventVC.currentAnimal = self.currentAnimal!
                editEventVC.lastVC = self.lastVC!
                editEventVC.thisVC = self.thisVC!
            }
        }
    }
    
    func reloadInfo(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Saved.shared.currentSettings.dateFormat
        self.NameLabel.text = "\(NSLocalizedString("name", comment: "")): \(currentEvent!.name)"
        self.DateLabel.text = "\(NSLocalizedString("date", comment: "")): \(dateFormatter.string(from: currentEvent!.date))"
        self.Descriptionlabel.text = "\(NSLocalizedString("description", comment: "")): \(currentEvent!.description!)"
    }
    
    private func ShowAlertActionSheet(){
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self](_) in
            
            self?.performSegue(withIdentifier: "goToEditEvent", sender: nil)
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
                    for event in animal.events_list{
                        if event == self!.currentEvent{
                            
                            let temp1: Animal = Saved.shared.currentSaves.animals[self!.num_animal]
                            temp1.events_list.remove(at: self!.num_event)
                            
                            Saved.shared.currentSaves.animals.remove(at: self!.num_animal)
                            Saved.shared.currentSaves.animals.insert(temp1, at: self!.num_animal)
                            
                            self?.navigationController?.popToViewController((self?.lastVC)!, animated: true)
                        }
                        self!.num_event += 1
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
