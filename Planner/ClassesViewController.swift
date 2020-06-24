//
//  ClassesViewController.swift
//  Planner
//
//  Created by 郑植 on 6/23/20.
//  Copyright © 2020 CSE 390. All rights reserved.
//

import UIKit
import CoreData

class ClassesViewController: UITableViewController {
    
    var events:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDatabase()
    }
    
    func loadDataFromDatabase() {
        //Set up core data context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject> (entityName: "Event")
        do {
            events = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: -Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell", for: indexPath)
        
        //Set up cell
        let event = events[indexPath.row] as? Event
        cell.textLabel?.text = event?.classes
        return cell
    }
}
