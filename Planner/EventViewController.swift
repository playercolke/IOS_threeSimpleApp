//
//  EventViewController.swift
//  Planner
//
//  Created by 郑植 on 6/23/20.
//  Copyright © 2020 CSE 390. All rights reserved.
//

import UIKit
import CoreData

class EventViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {
    
    var currentEvent:Event?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var classes: UITextField!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var dateChangeButton: UIButton!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentEvent != nil {
            eventName.text = currentEvent!.eventName
            classes.text = currentEvent!.classes
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentEvent!.dueDate != nil {
                dueDate.text = formatter.string(from: currentEvent!.dueDate!)
            }
        }
        
        self.changeEditMode(self)
        let textFields: [UITextField] = [eventName, classes]
        for textField in textFields {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentEvent == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentEvent = Event(context: context)
        }
        currentEvent?.eventName = eventName.text
        currentEvent?.classes = classes.text
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yy"
        currentEvent?.dueDate = formatter.date(from: (dueDate.text)!)
        return true
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [eventName, classes]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            dateChangeButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1{
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            dateChangeButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveEvent))
        }
    }
    
    @objc func saveEvent() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    func dateChanged(date: Date) {
        if currentEvent == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentEvent = Event(context: context)
        }
        currentEvent?.dueDate = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dueDate.text = formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueEventDate"){
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }
}
