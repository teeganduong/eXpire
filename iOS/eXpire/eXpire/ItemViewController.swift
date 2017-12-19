//
//  ItemViewController.swift
//  eXpire
//
//  Created by Scott English on 11/7/17.
//  Copyright © 2017 Scott English. All rights reserved.
//
//  View Controller for adding a new item or updating an existing item.
//

import UIKit
import os.log

class ItemViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var fooditemTextField: UITextField!
    @IBOutlet weak var foodtypeTextField: UITextField!
    @IBOutlet weak var foodquantityTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*
     This value is either passed by `FoodItemTableViewController` in `prepare(for:sender:)` *1
     or constructed as part of adding a new food item. *2
     */
    var food: Food?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fooditemTextField.delegate = self
        foodtypeTextField.delegate = self
        foodquantityTextField.delegate = self
        
        // If were editing a previous food item, set all ItemViewController UITextFields to there appropriate values. *1
        if let food = food{
            navigationItem.title = food.name
            fooditemTextField.text = food.name
            foodtypeTextField.text = food.type
            foodquantityTextField.text = String(food.quantity)
        }
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    // If the user pressed DONE, hide the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateSaveButtonState()
        self.view.endEditing(true)
    }
    
    // Disable the save button while the user is editing one of the UITextFields.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = fooditemTextField.text
    }
    
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view
        // controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        // If we are adding a meal, dissmiss this view controller upon cancel.
        if isPresentingInAddMealMode{
            dismiss(animated: true, completion: nil)
        }
        // If we were editing a meal, move back to the previous view controller upon cancel.
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("The FoodInventoryViewController is not inside a navigation controller.")
        }
        
    }
    
    // When we save the item's properties, we send the new instantiated food item through the segue to the InventoryTableViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, cancelling",log: OSLog.default, type: .debug)
            return
        }
        
        // Create the food item with values from UITextFields on ItemViewController.
        let name = fooditemTextField.text ?? ""
        let type = foodtypeTextField.text ?? ""
        let quantity = Int(foodquantityTextField.text!) ?? 0
        let timeCreated = Date()
        food = Food(name: name, type: type, quantity: quantity,timeCreated: timeCreated) // *2
    }
    
    
    //MARK: Private Methods
    // Update the save button if any text field is empty.
    private func updateSaveButtonState(){
        let text = fooditemTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    //MARK: Custom Methods
    // Method to resign all UITextField keyboards.
    private func ResignAllKeyBoard(){
        fooditemTextField.resignFirstResponder()
        foodtypeTextField.resignFirstResponder()
        foodquantityTextField.resignFirstResponder()
    }
}

