//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 14/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit
import os.log // import OSFrog lul

class MealViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RatingControlDelegate {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in
        `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Since this app behaves poorly in iOS 13 Dark Mode, in this and all view controllers, we should select light mode for the interface regardless of the user's current OS setting
        overrideUserInterfaceStyle = .light
        
        
        // Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // Handle the rating control's user input through delegate callbacks
        ratingControl.delegate = self
        
        // Save button should be greyed out until changes are made.
        disableSaveButton()
        
        // Set up views if editing an existing meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { //textFieldDidEndEditing is called when the mealNameLabel text field resigns it's first-responder status
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false // This makes sure that, in the case that we are editing a meal that already has a name, the button is disabled for the duration of text input.
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        // Try to enable the save button. Checking for a change in the photo selected is probably on the same order, performance wise, as saving the meal, so it's probably better to just enable save every time the image picker returns an image: the performance-heavy code is going to run a subset of the times a user selects a new image this way, and keeps the interface fluid
        safelyEnableSaveButton()
    }
    
    //MARK: RatingControlDelegate
    
    // whenever the rating button is tapped, we potentially want to enable the save button
    func ratingHasChanged() {
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // depending on the style of presentation (modal vs. push), this view controller needs to be dismissed in two different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The Save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        //Set the meal to be passed to MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) { // called when user taps the image view
        // hide the keyboard
        nameTextField.resignFirstResponder()
        
        // create a controller instance, set it's source to the photo library, and set this view controller as it's delegate
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self // makes sure ViewController is notified when user picks an image
        //present the controller
        present(imagePickerController, animated: true, completion: nil) // we do this with animation, and do not need to call a completion handler, so we write 'nil'
    }
    
    //MARK: Private methods
    
    // Enable the save button if new, valid meal data is present
    private func updateSaveButtonState() {
        // If no meal exists, we are creating a new meal and can try to enable the save button. If a meal exists, we must check that the name or rating has changed before enabling the save button, and disable the save button if nothing has changed
        
        if meal == nil {
            safelyEnableSaveButton()
            
        } else if meal!.name != nameTextField.text || meal!.rating != ratingControl.rating {
            // ^^ force-unwrap, because we just checked that a meal exists
            safelyEnableSaveButton()
            
        } else { // a meal exists and neither the name nor the rating has changed
            disableSaveButton()
        }
    }
    
    private func safelyEnableSaveButton() {
        // call safelyEnableSB or disableSB instead of modifying save button state. This ensures the save button is never enabled if the name text field is empty, since all meals MUST have a name.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func disableSaveButton() {
        saveButton.isEnabled = false
    }
    


}

