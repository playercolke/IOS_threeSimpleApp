// Jiating Su
// 111665989
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
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(EventViewController.keyboardDidShow(notification:)), name:
            UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(EventViewController.keyboardWillHide(notification:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        // Get the existing contentInset for the scrollView and set the bottom property to
        //be the height of the keyboard
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
