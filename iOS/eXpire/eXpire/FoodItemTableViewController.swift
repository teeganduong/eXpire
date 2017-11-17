//
//  FoodItemTableViewController.swift
//  eXpire
//
//  Created by Scott English on 11/16/17.
//  Copyright © 2017 Scott English. All rights reserved.
//

import UIKit
import os.log

class FoodItemTableViewController: UITableViewController {

    //MARK: Properties
    var fooditems = [Food]()
    
    //MARK: Actions
    @IBAction func unwindToFoodItemList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? FoodInventoryViewController, let food = sourceViewController.food {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                fooditems[selectedIndexPath.row] = food
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new Food Item.
                let newIndexPath = IndexPath(row: fooditems.count,section: 0)
                
                fooditems.append(food)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Private Methods
    private func LoadFoodInventory(){
        guard let food1 = Food(name: "Apple",type: "Fruit",quantity: 4)
            else{
                fatalError("Unable to instantiate meal1")
        }
        guard let food2 = Food(name: "Bannana",type: "Fruit",quantity: 3)
            else{
                fatalError("Unable to instantiate meal2")
        }
        guard let food3 = Food(name: "Orange",type: "Fruit",quantity: 1)
            else{
                fatalError("Unable to instantiate meal3")
        }
        
        fooditems += [food1,food2,food3]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the sample data
        LoadFoodInventory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fooditems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FoodItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FoodItemTableViewCell else{
            fatalError("The dequeued cell is not an instance of FoodItemTableViewCell.")
        }

        // Configure the cell...
        let fooditem = fooditems[indexPath.row]
        
        cell.foodnameLabel.text = fooditem.name
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            fooditems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let foodDetailViewController = segue.destination as? FoodInventoryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedFoodItemCell = sender as? FoodItemTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedFoodItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedFoodItem = fooditems[indexPath.row]
            foodDetailViewController.food = selectedFoodItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
 

}
