//
//  MealDisplayViewController.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 9/10/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit
import os.log

class MealDisplayViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    /*
     This value is either passed by `MealTableViewController` in
        `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        // This view requires a meal object to display. If no meal exists, error.
        if let meal = meal {
            navigationItem.title = "Meal Details"
            nameLabel.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
            ratingControl.isUserInteractionEnabled = false
        } else {
            os_log("Display controller was not passed valid meal object to display.", log: .default, type: .error)
        }
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destination = segue.destination as? UINavigationController else {
            os_log("Destination is not a navigation controller.", log: .default, type: .error)
            return
        }
        guard let targetMealViewController = destination.viewControllers[0] as? MealViewController else {
            os_log("Destination NavController does not contain a MealViewController as it's first view controller.", log: .default, type: .error)
            return
        }
        targetMealViewController.meal = meal
        targetMealViewController.didLoadFromDetailView(sender: self)
    }
    

}
