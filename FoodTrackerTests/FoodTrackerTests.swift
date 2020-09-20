//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Jacob Sephton on 14/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {

    //MARK: Meal class tests
    
    // confirm that the Meal initialiser returns a meal object when passed valid parameters
    func testMealInitializationSucceeds() {
        
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
        
    }
    
    // confirm initialisation fails (returns nil) when passed a negative rating, or an empty name
    func testMealInitializationFails() {
        
        // negative rating
        let negativeRatingMeal = Meal.init(name: "negative", photo: nil, rating: -4)
        XCTAssertNil(negativeRatingMeal)
        
        // rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // name string empty
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
    }

}
