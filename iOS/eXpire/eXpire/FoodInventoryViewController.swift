//
//  FoodInventoryViewController.swift
//  eXpire
//
//  Created by Scott English on 11/7/17.
//  Copyright © 2017 Scott English. All rights reserved.
//

import UIKit

class FoodInventoryViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var fooditemTextField: UITextField!
    @IBOutlet weak var foodtypeTextField: UITextField!
    @IBOutlet weak var foodquantityTextField: UITextField!
    
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    //MARK: Actions
    @IBAction func SaveFood(_ sender: UIButton) {
    }
    
    //MARK: Custom Functions
    func ResignAllKeyBoard(){
        fooditemTextField.resignFirstResponder()
        foodtypeTextField.resignFirstResponder()
        foodquantityTextField.resignFirstResponder()
    }
}

