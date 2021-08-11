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
    var dataReserved: [Event]?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var lastVC: UITableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataReserved = currentAnimal!.events_list
        if currentAnimal!.date_of_death != nil{
            self.addButton.isEnabled = false
        }
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = currentAnimal!.events_list
        if Saved.shared.currentSettings.sort == .up{
            data.sort(by: {$0.date < $1.date})
        } else {
            data.sort(by: {$0.date > $1.date})
        }
        
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
                infoE.thisVC = self
            }
        default:
            break
        }
    }
    
    func setEventsArray() -> [[Event]]{
        var arr: [[Event]] = [[]]
        arr.append([])
        for event in currentAnimal!.events_list{
            if event.date > Date(){
                arr[0].append(event)
            } else {
                arr[1].append(event)
            }
        }
        return arr
    }
    
    func setNumOfRows() -> [Int]{
        var num_future: Int = 0
        for event in currentAnimal!.events_list{
            if event.date > Date(){
                num_future += 1
            }
        }
        return [num_future, currentAnimal!.events_list.count - num_future]
    }
}

extension EventsTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumRows = setNumOfRows()[section]
        return sectionNumRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Future"
        } else {
            return "Past"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let first: Int = indexPath[0]
        let second: Int = indexPath[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        cell.textLabel?.text = "\(dateFormatter.string(from: setEventsArray()[first][second].date))  -  \(setEventsArray()[first][second].name)"
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        self.currentEvent = setEventsArray()[indexPath[0]][indexPath[1]]
        return indexPath
    }
}
