//
//  FoodInventoryViewController.swift
//  eXpire
//
//  Created by Scott English on 11/7/17.
//  Copyright © 2017 Scott English. All rights reserved.
//

import UIKit
import os.log

class FoodInventoryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
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
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, cancelling",log: OSLog.default, type: .debug)
            return
        }
        
        let name = fooditemTextField.text ?? ""
        let type = foodtypeTextField.text ?? ""
        let quantity = Int(foodquantityTextField.text!)
        
        food = Food(name: name, type: type, quantity: quantity!)
    }
    
    //MARK: Custom Functions
    func ResignAllKeyBoard(){
        fooditemTextField.resignFirstResponder()
        foodtypeTextField.resignFirstResponder()
        foodquantityTextField.resignFirstResponder()
    }
    
}

