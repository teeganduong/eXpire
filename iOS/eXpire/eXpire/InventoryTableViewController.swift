//
//  InventoryTableViewController.swift
//  eXpire
//
//  Created by Scott English on 11/16/17.
//  Copyright © 2017 Scott English. All rights reserved.
//
//  Home Screen UI TableViewController
//

import UIKit
import os.log

class InventoryTableViewController: UITableViewController {

    //MARK: Properties
    //var fooditems = [Food]() // Old array storage //
    var fridge = Fridge(dbFile: "eXpireDB.sqlite")

    
    //MARK: Actions
    // After coming back from ItemViewController, update TableView and fridge db.
    @IBAction func unwindToFoodItemList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? ItemViewController, let food = sourceViewController.food {
            // Updating existing food item.
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //fooditems[selectedIndexPath.row] = food // Old array storage. //
                fridge?.update(food: food, selectedIndexPath: selectedIndexPath.row)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                // Add a new Food Item.
                let newIndexPath = IndexPath(row: fridge!.count(),section: 0)
                
                //fooditems.append(food) // Old array storage.  //
                //tableView.insertRows(at: [newIndexPath], with: .automatic) // Old array storage. //
                
                // Add new food item to local db
                let expirationDate : Date? = Date()
                fridge?.insert(name: food.name as NSString, type: food.type as NSString, quantity: food.quantity, expireDate: expirationDate!, expired: false, timeCreated: food.timeCreated)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the sample data
        //LoadFoodInventory() // Old array Implementation. //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Override to return number of items in fridge db.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fridge?.count())!
    }
    
    // Override to support configuring a cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FoodItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InventoryTableViewCell else{
            fatalError("The dequeued cell is not an instance of FoodItemTableViewCell.")
        }
        // Configure the cell...
        let foodItem = fridge?.getItem(index: indexPath.row)
        //let fooditem = fooditems[indexPath.row] // Old array implementation.  //
        cell.foodnameLabel.text = foodItem?.name
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
            //fooditems.remove(at: indexPath.row) // Old array storage.  //
            fridge?.delete(index: indexPath.row)
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
            guard let foodDetailViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedFoodItemCell = sender as? InventoryTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedFoodItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            //let selectedFoodItem = fooditems[indexPath.row] // Old array implementation.  //
            let selectedFoodItem = fridge?.getItem(index: indexPath.row)
            foodDetailViewController.food = selectedFoodItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Private Methods. (Old array Implementation with default values)
    /*private func LoadFoodInventory(){
     
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
     }*/
}
