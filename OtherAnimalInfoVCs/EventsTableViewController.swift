//
//  EventsTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 04.08.2021.
//

import UIKit

class EventsTableViewController: UITableViewController {

    var currentAnimal: Animal?
    var data: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = currentAnimal!.events_list
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddEvent"{
            if let addEventVC = segue.destination as? AddEventViewController{
                addEventVC.currentAnimal = self.currentAnimal
            }
        }
    }
}

extension EventsTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnimal!.events_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        
        //TODO: - make date without time
        cell.textLabel?.text = "\(data[indexPath.row].name), \(data[indexPath.row].date)"
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        return indexPath
    }
}
