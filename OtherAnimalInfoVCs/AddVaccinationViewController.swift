//
//  AddVaccinationViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 03.08.2021.
//

import UIKit

//MARK: - protocols
protocol VaccDelegate: NSObject {
    func AddNew(_ vaccination: Vaccination)
}

protocol EditVaccDelegate: NSObject {
    func EditVacc(_ vaccination: Vaccination)
}

class AddVaccinationViewController: UIViewController {
    
    weak var addDelegate: VaccDelegate?
    weak var editDelegate: EditVaccDelegate?
    
    @IBOutlet weak var VaccName: UITextField!
    @IBOutlet weak var VaccDescription: UITextField!
    @IBOutlet weak var VaccDate: UIDatePicker!
    @IBOutlet weak var DateSwitcher: UISwitch!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nowlabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var lastVC: UITableViewController?
    var thisVC: UIViewController?
    
    var currentAnimal: Animal?
    var currentVaccination: Vaccination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        VaccDate.layer.borderColor = CGColor(red: CGFloat(Saved.shared.currentSettings.cellBackground_red/255), green: CGFloat(Saved.shared.currentSettings.cellBackground_green/255), blue: CGFloat(Saved.shared.currentSettings.cellBackground_blue/255), alpha: 1)
        VaccDate.layer.borderWidth = 7
        
        scrollView.contentSize.height = 1.0
        scrollView.contentInsetAdjustmentBehavior = .never
        Design.setupBackground(controller: self)
        VaccDate.maximumDate = Date()
        setupLabels()
        scrollView.isDirectionalLockEnabled = true
        if self.currentVaccination != nil {
            self.VaccName.text = self.currentVaccination!.name
            self.VaccDescription.text = self.currentVaccination!.description
            self.VaccDate.isEnabled = true
            self.DateSwitcher.isOn = false
            self.VaccDate.date = self.currentVaccination!.date
        }
    }
    
    private func setupConstraints() {
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -1000).isActive = true
        self.nameLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 40).isActive = true
    }
    
    private func setupLabels() {
        
        let constraints = [
            VaccName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: CGFloat(-30)),
            DateSwitcher.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nowlabel.leftAnchor.constraint(equalTo: DateSwitcher.rightAnchor, constant: 30),
            nowlabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        Design.setupTextField_Type2(field: VaccName)
        Design.setupTextField_Type2(field: VaccDescription)
        nameLabel.text = NSLocalizedString("name", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        nowlabel.text = NSLocalizedString("today", comment: "")
        descriptionLabel.text = NSLocalizedString("description", comment: "")
    }
    
    @IBAction func SwitchedDate(_ sender: UISwitch) {
        if DateSwitcher.isOn{
            VaccDate.isEnabled = false
        } else {
            VaccDate.isEnabled = true
        }
    }
    
    private func noSameVaccination(thisvacc: Vaccination) -> Bool {
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal == currentAnimal!{
                for vacc in Saved.shared.currentSaves.animals[num].vaccinations_list{
                    if thisvacc == vacc{
                        return false
                    }
                }
            }
            num += 1
        }
        return true
    }
    
    @IBAction func SaveVaccination(_ sender: Any) {
        if self.currentVaccination != nil{
            var num_animal: Int = 0
            var num_vacc: Int = 0
            for animal in Saved.shared.currentSaves.animals{
                if animal == self.currentAnimal!{
                    for vacc in animal.vaccinations_list{
                        if vacc == self.currentVaccination{
                            
                            let tempVacc = Saved.shared.currentSaves.animals[num_animal].vaccinations_list[num_vacc]
                            
                            tempVacc.name = self.VaccName.text!
                            tempVacc.date = self.VaccDate.date
                            tempVacc.description = self.VaccDescription.text!
                            if noSameVaccination(thisvacc: tempVacc){
                                if self.VaccName.text == ""{
                                    ShowAlertNoData()
                                } else {
                                    let temp: Animal = self.currentAnimal!
                                    temp.vaccinations_list[num_vacc] = tempVacc
                                    
                                    Saved.shared.currentSaves.animals.remove(at: num_animal)
                                    Saved.shared.currentSaves.animals.insert(temp, at: num_animal)
                                    self.currentVaccination = tempVacc
                                    editDelegate?.EditVacc(tempVacc)
                                }
                            } else {
                                ShowAlertSameVacc()
                                self.VaccName.text = currentVaccination!.name
                                self.VaccDate.date = currentVaccination!.date
                                break
                            }
                        }
                        num_vacc += 1
                    }
                }
                num_animal += 1
            }
        } else {
            if (VaccName.text != ""){
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
            var dateTxt = ""
            if DateSwitcher.isOn {
                dateTxt = dateFormatter.string(from: Date())
            } else{
                dateTxt = dateFormatter.string(from: VaccDate.date)
            }
                var num: Int = 0
                for animal in Saved.shared.currentSaves.animals{
                    if animal == currentAnimal!{
                        let tempVacc = Vaccination(name: VaccName.text!, descrpit: VaccDescription.text, date: dateTxt)
                        if noSameVaccination(thisvacc: tempVacc) {
                            currentAnimal!.vaccinations_list.append(tempVacc)
                            if Saved.shared.currentSettings.sort == .down{
                                currentAnimal!.vaccinations_list.sort(by: {$0.date > $1.date})
                            } else {
                                currentAnimal!.vaccinations_list.sort(by: {$0.date < $1.date})
                            }
                            Saved.shared.currentSaves.animals[num] = currentAnimal!
                            addDelegate?.AddNew(tempVacc)
                        } else {
                            ShowAlertSameVacc()
                        }
                    }
                    num += 1
                }
            } else {
                ShowAlertNoData()
            }
        }
    }
    
    private func ShowAlertSameVacc(){
        Alert.showBasicAlert(on: self, with: "Warning", message: "This vaccination already exists!")
    }
    
    private func ShowAlertNoData(){
        Alert.showIncompleteFormAlert(on: self)
    }
}
//MARK: - extensions
extension AddVaccinationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
}

extension VaccinationsTableViewController: VaccDelegate {
    func AddNew(_ vaccination: Vaccination) {
        self.dismiss(animated: true) {
            self.viewWillAppear(true)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension VaccInfoViewController: EditVaccDelegate {
    func EditVacc(_ vaccination: Vaccination) {
        dismiss(animated: true) {
            self.currentVaccination = vaccination
            self.reloadInfo()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
