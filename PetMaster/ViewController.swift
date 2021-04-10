//
//  ViewController.swift
//  PetMaster
//
//  Created by Fedor Sychev on 20.03.2021.
//

import UIKit

class ViewController: UIViewController{
    

    @IBOutlet weak var table1Text: UITextField!
    
    @IBOutlet var table: [UITableView]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView .beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        
        

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Pets"
        
       
        
        

        // Do any additional setup after loading the view.
    }


}

