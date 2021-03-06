//
//  EventInfoViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 07.08.2021.
//

import UIKit

protocol DeleteEventDelegate: NSObject {
    func DeleteEvent(_ animal: Animal)
}

class EventInfoViewController: UIViewController {

    var currentEvent: Event?
    var currentAnimal: Animal?
    
    var lastVC: UITableViewController?
    var thisVC: UITableViewController?
    
    weak var deleteDelegate: DeleteEventDelegate?
    
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
        
        Design.animateLabelAppear(label: self.NameLabel, delay: 0.0)
        Design.animateLabelAppear(label: self.DateLabel, delay: 0.3)
        Design.animateLabelAppear(label: self.Descriptionlabel, delay: 0.6)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditEvent"{
            if let editEventVC = segue.destination as? AddEventViewController{
                editEventVC.currentEvent = self.currentEvent!
                editEventVC.currentAnimal = self.currentAnimal!
                editEventVC.editProtocol = self
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
        let alert = UIAlertController(title: NSLocalizedString("options", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: NSLocalizedString("edit", comment: ""), style: .default) { [weak self](_) in
            
            self?.performSegue(withIdentifier: "goToEditEvent", sender: nil)
        }
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive) { [weak self](_) in
            self?.showAlert()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: NSLocalizedString("are_you_sure", comment: ""), message: nil, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default, handler: nil)
        
        let yesAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .destructive) { [weak self](_) in
            
            for animal in Saved.shared.currentSaves.animals{
                if animal.showInfo() == self!.currentAnimal!.showInfo(){
                    for event in animal.events_list{
                        if event == self!.currentEvent{
                            
                            let temp1: Animal = Saved.shared.currentSaves.animals[self!.num_animal]
                            temp1.events_list.remove(at: self!.num_event)
                            
                            Saved.shared.currentSaves.animals.remove(at: self!.num_animal)
                            Saved.shared.currentSaves.animals.insert(temp1, at: self!.num_animal)
                            
                            self!.deleteDelegate!.DeleteEvent(temp1)
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

extension EventsTableViewController: DeleteEventDelegate {
    func DeleteEvent(_ animal: Animal) {
        self.dismiss(animated: true) {
            self.currentAnimal = animal
            self.viewWillAppear(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
