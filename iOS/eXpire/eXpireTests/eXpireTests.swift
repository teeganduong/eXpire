//
//  eXpireTests.swift
//  eXpireTests
//
//  Created by Scott English on 11/7/17.
//  Copyright © 2017 Scott English. All rights reserved.
//

import XCTest
@testable import eXpire

class eXpireTests: XCTestCase {
    
    //MARK: Food Class Tests
    // Test confirms Food Item is returned when passed correct values
    func testFoodInitializationSucceeds(){
        
        // Lowest Quantity
        let zeroQuantityItem = Food.init(name: "Apple", type: "Fruit", quantity: 1)
        XCTAssertNotNil(zeroQuantityItem)
        // Highest Quantity
        let highestQuantityItem = Food.init(name: "Apple", type: "Fruit", quantity: 100)
        XCTAssertNotNil(highestQuantityItem)
    }
    
    // Test confirms nill value is returned when incorrect food values are given
    func testFoodInitializationFails(){
        
        // Negative Quantity
        let negativeQuantityItem = Food.init(name: "Apple", type: "Fruit", quantity: -5)
        XCTAssertNil(negativeQuantityItem)
        // Blank Food Name
        let blankFoodNameItem = Food.init(name: "", type: "Fruit", quantity: 100)
        XCTAssertNil(blankFoodNameItem)
        // Blank Food Type
        let blankFoodTypeItem = Food.init(name: "Apple", type: "", quantity: 100)
        XCTAssertNil(blankFoodTypeItem)
    }
    
}
