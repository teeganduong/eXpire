//
//  Fridge.swift
//  eXpire
//
//  Created by Teegan Duong on 11/18/17.
//  Copyright © 2017 Scott English. All rights reserved.
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
            let sqlString = " CREATE TABLE IF NOT EXISTS Fridge( " +
                "Id INTEGER PRIMARY KEY NOT NULL, " +
                "Title TEXT, " +
                "FoodType TEXT, " +
                "Quantity INT, " +
                "ExpireDate TEXT, " +
                "Expired INT, " +
                "TimeCreated TEXT);"
            var retStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, sqlString, -1, &retStatement, nil) == SQLITE_OK {
                if sqlite3_step(retStatement) == SQLITE_DONE {
                    print("Table creation success.")
                }else{
                    print("Table creation failure.")
                }
            }else{
                print("Table creation statement failed to be prepared.")
            }
            sqlite3_finalize(retStatement)
        }else{
            print("Failed to open local database.")
        }
        
    
    }
    
    // insert(n,t,q,ed,e) inserts the row (n,t,q,ed,e) into the Fridge
    func insert(name: String, type: String, quantity: Int, expireDate: Date, expired: Bool){
        let sqlString = "INSERT INTO Fridge (Title, FoodType, Quantity, ExpireDate, Expired, TimeCreated)" + "VALUES (?, ?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sqlString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, name, -1, nil)
            sqlite3_bind_text(insertStatement, 2, type, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(quantity))
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            let dateString = format.string(from: expireDate)
            sqlite3_bind_text(insertStatement, 4, dateString, -1, nil)
            if expired{
                sqlite3_bind_int(insertStatement, 5, 1)
            }else{
                sqlite3_bind_int(insertStatement, 5, 0)
            }
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            let currentTime = timeFormat.string(from: Date())
            sqlite3_bind_text(insertStatement,6,currentTime, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Insert success.")
            }else{
                print("Insert fail.")
            }
        }else{
            print("Insert failed to be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    // getItem(n) returns the food object stored in the nth place in the Fridge where the Fridge is a list of the food items stored in the local db sorted by TimeCreated (desc)
    func getItem(index: Int) -> Food{
        let sqlString = "SELECT * FROM Fridge GROUP BY TimeCreated DESC;"
        
        var selectStatement: OpaquePointer? = nil
        var foodList = [Food]()
        
        if sqlite3_prepare_v2(db, sqlString, -1, &selectStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(selectStatement) == SQLITE_ROW){
                let name: String = String(describing: sqlite3_column_text(selectStatement, 1))
                let type: String = String(describing: sqlite3_column_text(selectStatement,2))
                let quantity: Int = Int(sqlite3_column_int(selectStatement,3))
                let food: Food = Food(name: name, type: type, quantity: quantity)!
                foodList.append(food)
            }
            
        }else{
            print("Insert failed to be prepared.")
        }
        
        sqlite3_finalize(selectStatement)
        return foodList[index]
    }
    
    // delete(n) deletes a row r from the Fridge where r is the nth member of the Fridge sorted by TimeCreated (desc)
    func delete(index: Int){
        let sqlString = "SELECT Id FROM Fridge GROUP BY TimeCreated DESC;"
        
        var selectStatement: OpaquePointer? = nil
        var idList = [Int]()
        
        if sqlite3_prepare_v2(db, sqlString, -1, &selectStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(selectStatement) == SQLITE_ROW){
                let id: Int = Int(sqlite3_column_int(selectStatement, 0))
                idList.append(id)
            }
            
        }else{
            print("Insert failed to be prepared.")
        }
        
        sqlite3_finalize(selectStatement)
        
        let sqlString2 = "DELETE FROM Fridge WHERE Id = (?);"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sqlString2, -1, &deleteStatement, nil) == SQLITE_OK{
            sqlite3_bind_int(deleteStatement, 1, Int32(idList[index]))
            if sqlite3_step(deleteStatement) == SQLITE_DONE{
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
        let sqlString = "SELECT * FROM Fridge GROUP BY TimeCreated DESC;"
        
        var selectStatement: OpaquePointer? = nil
        var foodList = [Food]()
        
        if sqlite3_prepare_v2(db, sqlString, -1, &selectStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(selectStatement) == SQLITE_ROW){
                let name: String = String(describing: sqlite3_column_text(selectStatement, 1))
                let type: String = String(describing: sqlite3_column_text(selectStatement,2))
                let quantity: Int = Int(sqlite3_column_int(selectStatement,3))
                let food: Food = Food(name: name, type: type, quantity: quantity)!
                foodList.append(food)
            }
            
        }else{
            print("Insert failed to be prepared.")
        }
        
        sqlite3_finalize(selectStatement)
        return foodList
    }
}
