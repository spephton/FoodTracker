//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 17/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit
import os.log


class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    var meals = [Meal]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Since this app behaves poorly in iOS 13 Dark Mode, in this and all view controllers, we should select light mode for the interface regardless of the user's current OS setting
        overrideUserInterfaceStyle = .light
        
        // I used this code to double-check that the CVarArgs parameter of os_log does what I think it does. It did, and printed: "User interface style set to geese"
        // let testString = "geese"
        // os_log("User interface style set to %s", log: OSLog.default, type: .debug, testString)
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, else load sample data
        if let savedmeals = loadMeals() {
            meals += savedmeals
        } else {
            // Load sample data.
            loadSampleMeals()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "MealTableViewCell"
        
        // downcast to MealTableViewCell in this declaration
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }

        // Fetches the appropriate meal for the data source layout
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            // Delete the row from the data source
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: " + String(describing: sender))
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table.")
                
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default: fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        /* Here, we use the *optional type cast operator* `as?` to try to *downcast* the segue's source view controller to a MealViewController instance. This is necessary because sender.source is a type of UIViewController, but we want to work with a MealViewController. The reason sender.source is a UIViewController is because sender is of the class UIStoryboardSegue, which we haven't customised to specify a MealViewController.
         
            Additionally, we check that sourceViewController.meal is non-nil, and if it is non-nil, meaning that there's a meal property defined in the sourceViewController, we assign that property to our constant `meal`.
         */
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            //Check whether a row of the tableView is selected. If so, we're editing an existing meal. Load our edits to the table view. If not, the user has created a new meal, so we add it to the end of the table view
            if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
                meals[selectedIndexPaths[0].row] = meal
                tableView.reloadRows(at: selectedIndexPaths, with: .none) // probably what's causing the warning? is there some later point in the segue lifecycle where we can do this? Or maybe change the button action so that it calls an action method in meal view controller, which pops MealView off the nav stack before passing the segue?
            } else {
                
                // our path to the new meal insertion in the table view. We'll add at the position meals.count, which should be one after the last item in the list (since addressing begins at zero and count begins at one), and section 0 since there is only one section.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                // add the new meal to the data model before adding it to the table view
                meals.append(meal)
                // add the meal to the tableView
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the meals
            saveMeals()
            
        }
    }
    
    //MARK: Private methods
    
    private func loadSampleMeals() {
        
        // define photos for each meal
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        // store name, photo, and rating per meal in an array of objects
        let namesAndPhotosWithRating: [(name: String, photo: UIImage?, rating: Int)] = [("Caprese Salad", photo1, 4), ("Chicken and Potatoes", photo2, 5), ("Pasta with Meatballs", photo3, 3)]
        
        // throw an error if meal object creation is unsuccessful.
        func safelyGenerateMealObject(name: String, photo: UIImage?, rating: Int) -> Meal {
            guard let meal = Meal(name: name, photo: photo, rating: rating) else {
                fatalError("Unable to instantiate \(name)")
            }
            return meal
        }
        
       // generate all meals detailed in the namesAndPhotosWithRating array
        for object in namesAndPhotosWithRating {
            let meal = safelyGenerateMealObject(name: object.name, photo: object.photo, rating: object.rating)
            meals.append(meal)
        }
        
    }
    
    private func saveMeals() {
        do {
            // Encode meals into a data object
            let mealsData = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) // requiringSecureCoding: true threw an exception and I don't know why -- jacob
            // Write that data to the archive location in the documents folder
            try mealsData.write(to: Meal.ArchiveURL)
        } catch {
            os_log("Unable to encode/save meals due to error", log: OSLog.default, type: .error)
        }
        
        /* DEPRECATED SAVE IMPLEMENTATION
         let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
         if isSuccessfulSave {
              os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
         } else {
              os_log("Failed to save meals...", log: OSLog.default, type: .debug)
         }
        */
        
    }
    
    private func loadMeals() -> [Meal]? {
        
        // Should be called when the app is run on a clean install. This avoids throwing an error at Data(contentsOf:) in the course of expected program flow
        if !FileManager.default.fileExists(atPath: Meal.ArchiveURL.path) {
            os_log("Attempted to load from ` %s ` but no such file exists, aborting load.", log: OSLog.default, type: .debug, Meal.ArchiveURL.path)
            return nil
        } // This code was problematic before since fileExists expects a .path rather than an .absoluteString (the difference is that .absoluteString prepends file: followed by two forward slashes). Since the path was in an unexpected format, fileExists was always false, so the if branch was always taken and the function would return nil before the load could be performed.
        
        // Declared here for scope reasons ('do' blocks create new local scope)
        var mealsData: Data
        var mealsArray: [Meal]
        
        do {
            // Load data from file
            mealsData = try Data(contentsOf: Meal.ArchiveURL)
        } catch {
            // Scoured what documentation I could find for logging levels and I think that .error is the correct level if data cannot be retrieved.
            os_log("Failed to load meals data with error", log: OSLog.default, type: .error)
            return nil
        }
        
        do {
            // Decode data
            mealsArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mealsData) as! [Meal]
        } catch {
            os_log("Failed to unarchive loaded data with error", log: OSLog.default, type: .error)
            return nil
        }
        
        return mealsArray
        
        /* DEPRECATED LOAD IMPLEMENTATION
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
        */
    }
}
