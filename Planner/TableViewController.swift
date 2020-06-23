//
//  FirstViewController.swift
//  Planner
//
//  Created by 郑植 on 6/22/20.
//  Copyright © 2020 CSE 390. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController {

    
    var events:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadDataFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }

}

