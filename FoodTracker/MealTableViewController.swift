//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 17/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    var meals = [Meal]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load sample data.
        loadSampleMeals()

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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        /* Here, we use the *optional type cast operator* `as?` to try to *downcast* the segue's source view controller to a MealViewController instance. This is necessary because sender.sourceViewController is a type of UIViewController, but we want to work with a MealViewController.
         
            Additionally, we check that sourceViewController.meal is non-nil, and if it is non-nil, meaning that there's a meal property defined in the sourceViewController, we assign that property to our constant `meal`.
         */
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            // our path to the new meal insertion in the table view. We'll add at the position meals.count, which should be one after the last item in the list (since addressing begins at zero and count begins at one), and section 0 since there is only one section.
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            // add the new meal to the data model before adding it to the table view
            meals.append(meal)
            // add the meal to the tableView
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
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
}
