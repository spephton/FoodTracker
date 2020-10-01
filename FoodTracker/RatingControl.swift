//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 16/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit

// declare a delegate protocol so RatingControl can notify the containing view controller when the rating is updated
protocol RatingControlDelegate {
    func ratingHasChanged()
}

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]() // the parens at the end are more or less exactly the same as the parens at the end of a class instantiation, afaict. this is analogous to var ratingButton = UIButton(), but we're doing an array of them. I think, in this context, the pair of parens is called a 'constructor' -- it calls a subroutine to create an object, in this case, an array of a class.
    
    var delegate: RatingControlDelegate?
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet { // this is a property observer and is called whenever the associated property has it's value set.
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // if the selected star represents the current rating, we want to clear our rating
            rating = 0
        } else {
            // otherwise we set the rating to the selected star
            rating = selectedRating
        }
        
        //let the delegate know that the rating has changed (if a delegate is present)
        delegate?.ratingHasChanged()
        
    }
    
    //MARK: Private Methods
    
    private func setupButtons(){
        
        // clear existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load button images
        let bundle = Bundle(for: type(of: self)) // Bundle(for: RatingControl) refers to the app's main bundle, where images (and everything else) is kept. We would be able to instantiate UIImage with the shorter UIImage(named:) constructor, if it weren't for the fact that we want these images to display properly when the setup code is run in interface builder. Interface builder is fussier, and prefers to have the bundle specified, otherwise it won't work.
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0 ..< starCount {
            // create the button
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            // constrain button
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Add accessibility labels
            button.accessibilityLabel = "Set \(index + 1) star rating"
        
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside) // "A selector is an opaque value that identifies the method. Older APIs used selectors to dynamically invoke methods at runtime." replaced in newer APIs with blocks.
            // In the target-action design pattern, 'self' is the target (object with associated action method). In this context, self is the RatingControl instance that is created by the operating system when the app is run. The action method is 'ratingButtonTapped(button:)', which responds to an event on sender UIButton 'button'.
            // In summary, the target is the RatingControl instance, and the action is ratingButtonTapped(
        
        
            //add button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // if the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set"
            }
            
            // Assign both strings to the button
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
