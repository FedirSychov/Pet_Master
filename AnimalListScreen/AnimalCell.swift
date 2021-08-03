//
//  AnimalCell.swift
//  PetMaster
//
//  Created by Fedor Sychev on 13.07.2021.
//

import UIKit

class AnimalCell: UITableViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    
    @IBOutlet weak var animalNameLabel: UILabel!
    
    func setImage(image: Image) {
        imageView!.image = image.image
        animalNameLabel.text = image.title
    }
}
