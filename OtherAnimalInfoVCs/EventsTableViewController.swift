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
        Design.setupViewBehindTable(tableView: self.tableView)
        Design.setupBackgroundForTableView(tableView: self.tableView)
        dataReserved = currentAnimal!.events_list
        if currentAnimal!.date_of_death != nil{
            self.addButton.isEnabled = false
        }
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var num: Int = 0
        for animal in Saved.shared.currentSaves.animals{
            if animal == currentAnimal!{
                self.data = animal.events_list
            }
            num += 1
        }
        if Saved.shared.currentSettings.sort == .up{
            data.sort(by: {$0.date < $1.date})
        } else {
            data.sort(by: {$0.date > $1.date})
        }
        
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.sectionHeaderHeight = 100
        self.tableView.headerView(forSection: 0)!.backgroundColor = .green
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToAddEvent":
            if let addEventVC = segue.destination as? AddEventViewController{
                addEventVC.currentAnimal = self.currentAnimal
                addEventVC.addProtocol = self
            }
        case "goToEventnfo":
            if let infoE = segue.destination as? EventInfoViewController{
                infoE.currentAnimal = self.currentAnimal!
                infoE.currentEvent = self.currentEvent!
                infoE.lastVC = self.lastVC!
                infoE.thisVC = self
                infoE.deleteDelegate = self
            }
        default:
            break
        }
    }
    
    func setEventsArray() -> [[Event]]{
        var arr: [[Event]] = [[]]
        arr.append([])
        var tempEvents = currentAnimal!.events_list
        if Saved.shared.currentSettings.sort == .down{
            tempEvents.sort(by: {$0.date > $1.date})
        } else {
            tempEvents.sort(by: {$0.date < $1.date})
        }
        for event in tempEvents{
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
        if setNumOfRows()[0] == 0 || setNumOfRows()[1] == 0{
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionNumRows: Int
        if setNumOfRows()[0] == 0 {
            sectionNumRows = setNumOfRows()[1]
        } else if setNumOfRows()[1] == 0 {
            sectionNumRows = setNumOfRows()[0]
        } else {
            sectionNumRows = setNumOfRows()[section]
        }
        return sectionNumRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if setNumOfRows()[0] == 0 {
            return "Past"
        } else if setNumOfRows()[1] == 0{
            return "Plans"
        } else {
            if section == 0{
                return "Plans"
            } else {
                return "Past"
            }
        }
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let first: Int = indexPath[0]
        let second: Int = indexPath[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Saved.shared.currentSettings.dateFormat
        if setNumOfRows()[0] == 0 {
            cell.textLabel?.text = "\(dateFormatter.string(from: setEventsArray()[1][second].date))  -  \(setEventsArray()[1][second].name)"
        } else if setNumOfRows()[1] == 0 {
            cell.textLabel?.text = "\(dateFormatter.string(from: setEventsArray()[0][second].date))  -  \(setEventsArray()[0][second].name)"
        } else {
            cell.textLabel?.text = "\(dateFormatter.string(from: setEventsArray()[first][second].date))  -  \(setEventsArray()[first][second].name)"
        }
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: 24)
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        if setNumOfRows()[0] == 0 {
            self.currentEvent = setEventsArray()[1][indexPath[1]]
        } else if setNumOfRows()[1] == 0 {
            self.currentEvent = setEventsArray()[0][indexPath[1]]
        } else {
            self.currentEvent = setEventsArray()[indexPath[0]][indexPath[1]]
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 100))
        tableView.estimatedSectionHeaderHeight = 100
        returnedView.backgroundColor = UIColor.clear

        let label = UILabel(frame: CGRect(x: self.tableView.frame.size.width/2 - 40, y: 4, width: 100, height: 20))

            label.font = UIFont(name: "Avenir Next Medium", size: 32)

        if setNumOfRows()[0] == 0 {
            label.text = "Past"
        } else if setNumOfRows()[1] == 0{
            label.text = "Plans"
        } else {
            if section == 0{
                label.text = "Plans"
            } else {
                label.text = "Past"
            }
        }
                    //returnedView.addSubview(label)
                    return returnedView
                }
}
