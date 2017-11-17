//
//  ItemViewController.swift
//  eXpire
//
//  Created by Scott English on 11/7/17.
//  Copyright © 2017 Scott English. All rights reserved.
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
     This value is either passed by `FoodItemTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new food item.
     */
    var food: Food?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fooditemTextField.delegate = self
        foodtypeTextField.delegate = self
        foodquantityTextField.delegate = self
        
        if let food = food{
            navigationItem.title = food.name
            fooditemTextField.text = food.name
            foodtypeTextField.text = food.type
            foodquantityTextField.text = String(food.quantity)
        }
        
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button while editing
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
        
        if isPresentingInAddMealMode{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("The FoodInventoryViewController is not inside a navigation controller.")
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, cancelling",log: OSLog.default, type: .debug)
            return
        }
        
        let name = fooditemTextField.text ?? ""
        let type = foodtypeTextField.text ?? ""
        let quantity = Int(foodquantityTextField.text!) ?? 0
        
        food = Food(name: name, type: type, quantity: quantity)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        // Update the save button if any text field is empty.
        let text = fooditemTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    //MARK: Custom Methods
    func ResignAllKeyBoard(){
        fooditemTextField.resignFirstResponder()
        foodtypeTextField.resignFirstResponder()
        foodquantityTextField.resignFirstResponder()
    }
    
}

