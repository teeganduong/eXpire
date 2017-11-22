//
//  Fridge.swift
//  eXpire
//
//  Created by Teegan Duong on 11/18/17.
//  Copyright © 2017 Scott English. All rights reserved.
//
//  Fridge Database Class
//

import Foundation
import SQLite3

class Fridge{
    var db: OpaquePointer? = nil
    
    //MARK: Initializer
    init?(dbFile: String){
        
        //create a file path pointing to the database to open
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) == SQLITE_OK {
            self.db = db
            // Temporary Delete Table Code.
//            let sql2String = " DROP TABLE IF EXISTS Fridge;"
//            var ret2Statement: OpaquePointer? = nil
//            if sqlite3_prepare_v2(db, sql2String, -1, &ret2Statement, nil) == SQLITE_OK {
//                if sqlite3_step(ret2Statement) == SQLITE_DONE {
//                    print("Table drop success.")
//                }else{
//                    print("Table drop failure.")
//                }
//            }else{
//                print("Table drop statement failed to be prepared.")
//            }
            // Create db Table with schema Fridge(Id Int Primary Key Not Null, Title Txt, FoodType Txt, Qnty, Txt, ExpDate Txt, TimeCrtd Txt).
            let sqlString = " CREATE TABLE IF NOT EXISTS Fridge( " +
                "Id INTEGER PRIMARY KEY NOT NULL, " +
                "Title TEXT, " +
                "FoodType TEXT, " +
                "Quantity INT, " +
                "ExpireDate TEXT, " +
                "Expired INT, " +
                "TimeCreated TEXT);"
            var retStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, sqlString, -1, &retStatement, nil) == SQLITE_OK { // Compile the sqlite3 statement.
                if sqlite3_step(retStatement) == SQLITE_DONE { // Find out if sqlite3 statment is done.
                    print("Table creation success.")
                }else{
                    print("Table creation failure.")
                }
            }else{
                print("Table creation statement failed to be prepared.")
            }
            sqlite3_finalize(retStatement) // Finish sql command.
        }else{
            print("Failed to open local database.")
        }
        
    
    }
    
    
    //MARK: Custom Methods
    // insert(n,t,q,ed,e) inserts the row (n,t,q,ed,e) into the Fridge db.
    func insert(name: NSString, type: NSString, quantity: Int, expireDate: Date, expired: Bool, timeCreated: Date){
        let sqlString = "INSERT INTO Fridge (Title, FoodType, Quantity, ExpireDate, Expired, TimeCreated)" + "VALUES (?, ?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sqlString, -1, &insertStatement, nil) == SQLITE_OK { // Compile the sqlite3 statement.
            
            // Bind all sqlite3 values ? with swift values with indexing starting at 1.
            sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, type.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(quantity))
            
            // Format the expiration date from type Date to type NSString.
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let dateString = format.string(from: expireDate) as NSString
            sqlite3_bind_text(insertStatement, 4, dateString.utf8String, -1, nil)
            if expired{
                sqlite3_bind_int(insertStatement, 5, 1)
            }else{
                sqlite3_bind_int(insertStatement, 5, 0)
            }
            
            // Format the timestamp date from type Date to type NSString.
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            let currentTime = timeFormat.string(from: timeCreated) as NSString
            sqlite3_bind_text(insertStatement,6,currentTime.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{ // Find out if sqlite3 statment is done.
                print("Insert success.")
            }else{
                print("Insert fail.")
            }
        }else{
            print("Insert failed to be prepared.")
        }
        
        sqlite3_finalize(insertStatement) // Finish sql command.
    }
    
    // getItem(n) returns the food object stored in the nth place in the Fridge where the Fridge is a list of the food items stored in the local db sorted by TimeCreated (ascending)
    func getItem(index: Int) -> Food{
        let sqlString = "SELECT * FROM Fridge ORDER BY TimeCreated ASC;"
        
        var selectStatement: OpaquePointer? = nil
        var foodList = [Food]()
        
        if sqlite3_prepare_v2(db, sqlString, -1, &selectStatement, nil) == SQLITE_OK { // Compile the sqlite3 statement.
            
            while (sqlite3_step(selectStatement) == SQLITE_ROW){ // Step through each sqlite3_row in the fridge db.
                
                // Collect each value in each field for the sqlite_row we are on.
                let col1Result = sqlite3_column_text(selectStatement, 1)
                let name = String(cString: col1Result!)
                let col2Result = sqlite3_column_text(selectStatement, 2)
                let type = String(cString: col2Result!)
                let quantity = Int(sqlite3_column_int(selectStatement,3))
                let col3Result = sqlite3_column_text(selectStatement, 6)
                let dateString = String(cString: col3Result!)
                
                // Format the timestamp date from type String to type Date.
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
                let date = format.date(from: dateString)
                
                // If we found an item for this row, append it to our list.
                // This list should represent our values in the fridge db just as they are listed in the InventoryTableViewController.
                if (!name.isEmpty){
                    let food: Food = Food(name: name, type: type, quantity: quantity, timeCreated: date!)!
                    foodList.append(food)
                }
            }
            
        }else{
            print("Insert failed to be prepared.")
        }
        
        sqlite3_finalize(selectStatement) // Finish sql command.
        return foodList[index]
    }
    
    // delete(n) deletes a row r from the Fridge where r is the nth member of the Fridge sorted by TimeCreated (ascending)
    func delete(index: Int){
        
        let sqlString = "SELECT Id FROM Fridge ORDER BY TimeCreated ASC;"
        var selectStatement: OpaquePointer? = nil
        var idList = [Int]()
        
        // Find the food item were wanting to delete.
        if sqlite3_prepare_v2(db, sqlString, -1, &selectStatement, nil) == SQLITE_OK { // Compile the sqlite3 statement.
            while (sqlite3_step(selectStatement) == SQLITE_ROW){ // Step through each sqlite3_row in the fridge db.
                let id: Int = Int(sqlite3_column_int(selectStatement, 0))
                idList.append(id)
            }
        }else{
            print("Insert failed to be prepared.")
        }
        sqlite3_finalize(selectStatement) // Finish sql command.
        
        // Delete the food item from the fridge db.
        let sqlString2 = "DELETE FROM Fridge WHERE Id = (?);"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sqlString2, -1, &deleteStatement, nil) == SQLITE_OK{ // Compile the sqlite3 statement.
            sqlite3_bind_int(deleteStatement, 1, Int32(idList[index]))
            if sqlite3_step(deleteStatement) == SQLITE_DONE{ // Find out if sqlite3 statment is done.
                print("Delete success.")
            }else{
                print("Delete failure.")
            }
        }else{
            print("Delete statement could not be prepared.")
        }
    }
    
    // getAllItem() returns a list of every food object stored in the Fridge where the Fridge is a list of the food items stored in the local db sorted by TimeCreated (desc)
    func getAllItem() -> [Food]{
        
        let sqlString = "SELECT * FROM Fridge ORDER BY TimeCreated ASC;"
        var selectStatement: OpaquePointer? = nil
        var foodList = [Food]()
        
        if sqlite3_prepare_v2(db, sqlString, -1, &selectStatement, nil) == SQLITE_OK { // Compile the sqlite3 statement.
            while (sqlite3_step(selectStatement) == SQLITE_ROW){ // Step through each sqlite3_row in the fridge db.
                
                // Collect each field value from the row.
                let col1Result = sqlite3_column_text(selectStatement, 1)
                let name = String(cString: col1Result!)
                let col2Result = sqlite3_column_text(selectStatement, 2)
                let type = String(cString: col2Result!)
                let quantity = Int(sqlite3_column_int(selectStatement,3))
                let col3Result = sqlite3_column_text(selectStatement, 6)
                let dateString = String(cString: col3Result!)
                
                // Format the timestamp from type String to type Date.
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
                let date = format.date(from: dateString)
                
                // If we found an item for this row, append it to our list.
                // This list should represent our values in the fridge db just as they are listed in the InventoryTableViewController.
                if (!name.isEmpty){
                    let food: Food = Food(name: name, type: type, quantity: quantity, timeCreated: date!)!
                    foodList.append(food)
                }
            }
        }else{
            print("Insert failed to be prepared.")
        }
        sqlite3_finalize(selectStatement) // Finish sql command.
        return foodList
    }
    
    // Returns the number of items in the database.
    func count() -> Int{
        let list = getAllItem()
        return list.count
    }
    
    //Updates an existing item in the database.
    func update(food: Food, selectedIndexPath: Int){
        
        let oldFood = getItem(index: selectedIndexPath)
        let name = food.name as NSString
        let type = food.type as NSString
        
        // Format timestamp of previous food item from type Date to type NSString.
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = format.string(from: oldFood.timeCreated) as NSString
        let sqlString = "UPDATE Fridge SET Title = ?, FoodType = ?, Quantity = ? WHERE TimeCreated = ?;"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sqlString, -1, &updateStatement, nil) == SQLITE_OK { // Compile the sqlite3 statement.
            // If the sqlite3 statment compiled correctly, append our new values for updating to the sqlite3 statment.
            sqlite3_bind_text(updateStatement, 1, name.utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, type.utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(food.quantity))
            sqlite3_bind_text(updateStatement, 4, dateString.utf8String, -1, nil)
            if sqlite3_step(updateStatement) == SQLITE_DONE{ // Find out if sqlite3 statment is done.
                print("Update success.")
            }else{
                print("Update fail.")
            }
        }else{
            print("Update failed to be prepared.")
        }
        
        sqlite3_finalize(updateStatement) // Finish sql command.
    }
}
