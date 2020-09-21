//
//  Meal.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 17/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Archiving Paths
    
    // urls(for:in:) returns an array of URLS in the document directory, accessible to the user. The first option of this array is an optional containing the first URL. However, the returned array should always contain exactly one match, so we can force-unwrap by appending `!`
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
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
        
        super.init()
        
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // the name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Meal, just use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer
        self.init(name: name, photo: photo, rating: rating)
    }
}
