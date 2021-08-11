//
//  AnimalTableViewCell.swift
//  PetMaster
//
//  Created by Fedor Sychev on 11.08.2021.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {
    
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var animalName: UILabel!
    @IBOutlet var animalStatus: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "AnimalTableViewCell", bundle: nil)
    }
    
    static let identifier = "AnimalTableViewCell"
    
    public func configure(with animal: Animal) {
        if animal.animal_image == "" || animal.animal_image == nil {
            myImageView.image = #imageLiteral(resourceName: "NoImage")
        } else {
            myImageView.image = getImageFromDocs(name: animal.animal_image!)
        }
        animalName.text = animal.name
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.masksToBounds = false
        myImageView.layer.borderColor = UIColor.white.cgColor
        myImageView.layer.cornerRadius = myImageView.frame.size.width / 2
        myImageView.clipsToBounds = true
        animalStatus.text = updateStatus(currentAnimal: animal)
    }
    
    func updateStatus(currentAnimal: Animal) -> String{
        var currDiseaseNum: Int = -1
        if currentAnimal.disease_list.count > 0{
            var temp: Int = 0
            for disease in currentAnimal.disease_list{
                if disease.date_of_end == nil{
                    currDiseaseNum = temp
                    break
                }
                temp += 1
            }
            if currDiseaseNum != -1{
                return "Sick"
            } else {
                return "Healthy"
            }
        }
        if currentAnimal.date_of_death != nil{
            return "Dead"
        }
        return "Healthy"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getImageFromDocs(name: String) -> UIImage?{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            let image    = UIImage(contentsOfFile: imageURL.path)
           return image
        }
        return nil
    }

}
