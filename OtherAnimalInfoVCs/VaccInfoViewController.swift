//
//  VaccInfoViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 05.08.2021.
//

import UIKit

class VaccInfoViewController: UIViewController {

    var currentVaccination: Vaccination?
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        self.NameLabel.text = "Name: \(currentVaccination!.name)"
        self.DateLabel.text = "Date: \(dateFormatter.string(from: currentVaccination!.date))"
        //self.DateLabel.text = "Date: \(currentVaccination!.date)"
        self.DescriptionLabel.text = "Description: \(currentVaccination!.description!)"
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
