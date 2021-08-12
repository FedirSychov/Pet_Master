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
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentLabel.text = NSLocalizedString("comment", comment: "")
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
        let alert = UIAlertController(title: NSLocalizedString("oh_no", comment: ""), message: NSLocalizedString("pity_message", comment: ""), preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self](_) in
            self?.navigationController?.popToViewController(self!.lastVC!, animated: true)
        }
        
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
}
