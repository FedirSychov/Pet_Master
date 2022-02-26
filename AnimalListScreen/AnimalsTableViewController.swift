//
//  AnimalsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 30.07.2021.
//

import UIKit

class AnimalsTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var data:[Animal] = []
    var currentAnimal: Animal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackground(controller: self)
        tableView.register(AnimalTableViewCell.nib(), forCellReuseIdentifier: AnimalTableViewCell.identifier)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        data = Saved.shared.currentSaves.animals
        self.tableView.reloadData()
    }
    
    @IBAction func AddNewAnimal(_ sender: Any) {
        if AppVersion.isFullVersion || (!AppVersion.isFullVersion && Saved.shared.currentSaves.animals.count < 5) {
            performSegue(withIdentifier: "addNewAnimal", sender: nil)
        } else {
            Alert.showBasicAlert(on: self, with: "Warning", message: "For adding 5 and more animals you should have a full version!")
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goToAnimalInfo":
            
            if let vc = segue.destination as? AnimalViewController{
                vc.currentAnimal = self.currentAnimal
                vc.lastVC = self
            }
        case "addNewAnimal":
            if let navVC = segue.destination as? UINavigationController, let newVC = navVC.topViewController as? AddAnimalViewController{
                newVC.delegate = self
            }
        default:
            break
        }
    }
    
    
}
//MARK: - TableView
extension AnimalsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Saved.shared.currentSaves.animals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnimalTableViewCell.identifier, for: indexPath) as! AnimalTableViewCell
        cell.configure(with: data[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentAnimal = data[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToAnimalInfo", sender: nil)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.data.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        Saved.shared.currentSaves.animals.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.tableView.isEditing = true
            } else {
                self.tableView.isEditing = false
            }
        }
    }
}
