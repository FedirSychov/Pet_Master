//
//  MoneyHistoryTableViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 15.08.2021.
//

import UIKit

class MoneyHistoryTableViewController: UITableViewController {
    
    var data: [Expenditure]?
    var data_array: [[Expenditure]]?
    var monthes_array: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.data = Saved.shared.currentExpenditures.allExpenditures
        getArrayOfExpenditures()
    }
    
    private func setupView() {
        Design.setupBackgroundForTableView(tableView: self.tableView)
        Design.setupViewBehindTable(tableView: self.tableView)
    }
    
    private func getArrayOfExpenditures() {
        var array_data: [[Expenditure]] = []
        var current_month_year = [0, 0]
        
        self.monthes_array = []
        if self.data!.count != 0 {
            for _ in 1...months(from: data![0].date) {
                array_data.append([])
            }
        } else {
            array_data.append([])
        }

        if self.data!.count > 0 {
            for n in 1...self.data!.count {
                let exp = self.data![self.data!.count - n]
                let tempComponents = Calendar.current.dateComponents([.year, .month], from: exp.date)
                
                let temp_month_year = [tempComponents.month, tempComponents.year]
                
                if current_month_year != temp_month_year {
                    self.monthes_array?.append("\(temp_month_year[0]!)/\(temp_month_year[1]!)")
                    current_month_year[0] = temp_month_year[0]!
                    current_month_year[1] = temp_month_year[1]!
                }
                array_data[self.monthes_array!.count - 1].append(exp)
                
            }
        } else {
            
        }
        
        
        self.data_array = array_data
    }
    
    private func months(from date: Date) -> Int {
            return Calendar.current.dateComponents([.month], from: date, to: Date()).month! + 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.data_array!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.data_array![section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MoneyCell")
        let first = indexPath[0]
        let second = indexPath[1]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Saved.shared.currentSettings.dateFormat
        
        cell.textLabel!.text = "\(dateFormatter.string(from: self.data_array![first][second].date)) | \(self.data_array![first][second].summ) | \(self.data_array![first][second].name)"
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: 20)
        cell.backgroundColor = UIColor.clear
        
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
        tableView.estimatedSectionHeaderHeight = 200
        returnedView.backgroundColor = UIColor.clear

        let label = UILabel(frame: CGRect(x: 18, y: 20, width: 300, height: 34))

            label.font = UIFont(name: "Avenir Next Medium", size: 32)

        if monthes_array!.count > 0 {
            label.text = monthes_array![section]
        } else {
            label.text = ""
        }
            
                    returnedView.addSubview(label)
            return returnedView
        }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let chosenExp = data_array![indexPath.section][indexPath.row]
            var tempArray = Saved.shared.currentExpenditures.allExpenditures
            var num: Int = 0
            for exp in tempArray {
                if exp.date == chosenExp.date && exp.name == chosenExp.name && exp.summ == chosenExp.summ {
                    tempArray.remove(at: num)
                    Saved.shared.currentExpenditures.allExpenditures = tempArray
                    self.viewDidLoad()
                    tableView.reloadData()
                }
                num += 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
