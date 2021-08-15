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
        //Design.setupBackground(controller: self)
        Design.setupViewBehindTable(tableView: self.tableView)
    }
    
    private func getArrayOfExpenditures() {
        var array_data: [[Expenditure]] = []
        var current_month_year = [0, 0]
        
        self.monthes_array = []
        
        for _ in 1...months(from: data![0].date) {
            array_data.append([])
        }
        
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
        
        cell.textLabel!.text = "\(self.data_array![first][second].name) | \(dateFormatter.string(from: self.data_array![first][second].date)) | \(self.data_array![first][second].summ)"
        cell.textLabel?.font = UIFont(name: "Avenir Next Medium", size: 24)
        cell.backgroundColor = UIColor.clear
        
        Design.setupBackgroundForCells(cell: cell)
        return cell
    }
}
