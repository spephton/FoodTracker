//
//  Meal.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 17/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialization
    
    init? (name: String, photo: UIImage?, rating: Int) {
        self.name = name
        self.photo = photo
        self.rating = rating
        
        // init should fail if there is no name
        guard !name.isEmpty else {
            return nil
        }
        
        // or rating has been set to a negative number, or is greater than five
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        
    }
}
