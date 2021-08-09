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
    var currentImage: String?
    
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
        if self.currentAnimal?.animal_image != nil{
            AnimalImage.image = getImageFromDocs(name: currentAnimal!.animal_image!)
        } else {
            AnimalImage.image = #imageLiteral(resourceName: "NoImage")
        }
        
        updateStatus()
    }
    
    func ReloadStatus() {
        var temp1: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal.showInfo() == self.currentAnimal?.showInfo(){
                self.currentAnimal = animal
                StatusLabel.text = "Sick"
                MakeHealthy.alpha = 1
                MakeHealthy.isEnabled = true
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
                MakeHealthy.alpha = 1
                MakeHealthy.isEnabled = true
            } else {
                StatusLabel.text = "Healthy"
                MakeHealthy.alpha = 0
                MakeHealthy.isEnabled = false
            }
            NameLabel.text = "Name: \(currentAnimal!.name)"
            AgeLabel.text = "Age: \(currentAnimal!.animal_age)"
            TypeLabel.text = "Type: \(currentAnimal!.animal_type)"
            BreedLabel.text = "Breed: \(currentAnimal!.animal_breed!)"
        }
        else {
            StatusLabel.text = "Healthy"
            MakeHealthy.alpha = 0
            MakeHealthy.isEnabled = false
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
        MakeHealthy.alpha = 0
        MakeHealthy.isEnabled = false
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
        
        let imageAction = UIAlertAction(title: "Set photo as avatar", style: .default) { [weak self](_) in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            self?.present(vc, animated: true, completion: nil)
            
        }
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "EditAnimal", sender: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self](_) in
            self?.showAlert()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(imageAction)
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

extension AnimalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            AnimalImage.image = image
            if self.currentAnimal!.animal_image != nil{
                deleteImageFromDocs(name: self.currentAnimal!.animal_image!)
            }
            currentImage = "\(self.currentAnimal!.name)-\(self.currentAnimal!.animal_type)-\(self.currentAnimal!.date_of_birth)"
            let succsess = saveImage(image: image, name: currentImage!)
            if succsess{
                currentAnimal!.animal_image = self.currentImage
                var num: Int = 0
                for animal in Saved.shared.currentSaves.animals{
                    if animal.showInfo() == currentAnimal!.showInfo(){
                        Saved.shared.currentSaves.animals.remove(at: num)
                        Saved.shared.currentSaves.animals.insert(currentAnimal!, at: num)
                    }
                    num += 1
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getImageFromDocs(name: String) -> UIImage?{
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            let image    = UIImage(contentsOfFile: imageURL.path)
            print("That's OK")
           return image
        }
        return nil
    }
    
    func deleteImageFromDocs(name: String){
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            do{
                try? fileManager.removeItem(at: URL(fileURLWithPath: dirPath).appendingPathComponent(name))
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
