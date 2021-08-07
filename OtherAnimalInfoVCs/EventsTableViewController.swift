//
//  EventsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 04.08.2021.
//

import UIKit

class EventsTableViewController: UITableViewController {

    var currentAnimal: Animal?
    var currentEvent: Event?
    var data: [Event] = []
    
    var lastVC: UITableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = currentAnimal!.events_list
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddEvent":
            if let addEventVC = segue.destination as? AddEventViewController{
                addEventVC.currentAnimal = self.currentAnimal
            }
        case "goToEventnfo":
            if let infoE = segue.destination as? EventInfoViewController{
                infoE.currentAnimal = self.currentAnimal!
                infoE.currentEvent = self.currentEvent!
                infoE.lastVC = self.lastVC!
            }
        default:
            break
        }
    }
}

extension EventsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimal!.events_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        cell.textLabel?.text = "\(data[indexPath.row].name), \(dateFormatter.string(from: data[indexPath.row].date))"
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        let num: Int = indexPath.row
        self.currentEvent = data[num]
        return indexPath
    }
}
