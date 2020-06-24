//
//  FirstViewController.swift
//  Planner
//
//  Created by 郑植 on 6/22/20.
//  Copyright © 2020 CSE 390. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    
    var events:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadDataFromDatabase()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let convertedDate = formatter.string(from: date)
        self.title = convertedDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    func loadDataFromDatabase() {
        //Set up Core Data Context
        let context = appDelegate.persistentContainer.viewContext
        //Set up Request
        let request = NSFetchRequest<NSManagedObject>(entityName: "Event")
        do {
            events = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source

      override func numberOfSections(in tableView: UITableView) -> Int {
          return 1
      }

      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return events.count
      }

     
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath) as! TableViewCell
          // Configure the cell...
          let event = events[indexPath.row] as? Event
          cell.main.text = event?.eventName
          cell.subTitle.text = event?.classes
          let formatter = DateFormatter()
          formatter.dateStyle = .short
          cell.time.text = formatter.string(from: (event?.dueDate)!)
          return cell
      }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let selectedEvent = events[indexPath.row] as? Event
          let name = selectedEvent!.eventName!
          let actionHandler = { (action:UIAlertAction!) -> Void in
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let controller = storyboard.instantiateViewController(withIdentifier: "EventController")
                  as? EventViewController
              controller?.currentEvent = selectedEvent
              self.navigationController?.pushViewController(controller!, animated: true)
          }
          
          let alertController = UIAlertController(title: "Contact selected",
                                                  message:  "Selected row: \(indexPath.row) (\(name))",
              preferredStyle: .alert)
          
          let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)
          alertController.addAction(actionCancel)
          alertController.addAction(actionDetails)
          present(alertController, animated: true, completion: nil)
      }

      /*
      // Override to support conditional editing of the table view.
      override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          // Return false if you do not want the specified item to be editable.
          return true
      }
      */

      override func tableView(_ tableView: UITableView,
                              commit editingStyle: UITableViewCell.EditingStyle,
                              forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Delete the row from the data source
              let event = events[indexPath.row] as? Event
              let context = appDelegate.persistentContainer.viewContext
              context.delete(event!)
              do {
                  try context.save()
              }
              catch  {
                  fatalError("Error saving context: \(error)")
              }
              loadDataFromDatabase()
              tableView.deleteRows(at: [indexPath], with: .fade)
          } else if editingStyle == .insert {
              // Create a new instance of the appropriate class, insert it into the array,
              //and add a new row to the table view
          }
      }

      
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "EditEvent" {
              let eventController = segue.destination as? EventViewController
              let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
              let selectedEvent = events[selectedRow!] as? Event
              eventController?.currentEvent = selectedEvent!
          }
      }
}

