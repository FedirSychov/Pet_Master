//
//  DeathViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 10.08.2021.
//

import UIKit

class DeathViewController: UIViewController {

    var currentAnimal: Animal?
    var lastVC: UITableViewController?
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var CommentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatePicker.backgroundColor = .lightGray
    }
    
    @IBAction func SaveDeath(_ sender: Any) {
        currentAnimal!.date_of_death = DatePicker.date
        currentAnimal!.deathComment = CommentTextField.text
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal.showInfo() == currentAnimal!.showInfo(){
                Saved.shared.currentSaves.animals.remove(at: num)
                Saved.shared.currentSaves.animals.insert(currentAnimal!, at: num)
                showAlert()
            }
            num += 1
        }
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Oh no", message: "What a pity :( Maybe you want to have a new pet?", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { [weak self](_) in
            self?.navigationController?.popToViewController(self!.lastVC!, animated: true)
        }
        
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
}
