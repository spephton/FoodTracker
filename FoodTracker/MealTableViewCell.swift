//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Jacob Sephton on 17/9/20.
//  Copyright © 2020 Jacob Sephton. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //print("MealTableViewCell awoke from NIB!") // this gets printed on initial load, per cell, nice.
        // try getting dimensions of bounds
        // print("my width is \(self.bounds.width), and my height is \(self.bounds.height)") // w 375pts, h 90pts. This is what we expect: the width of the device (iPhone 8) in points. EDIT turns out that this *happened* to match the device I was testing on, and bounds isn't set properly in awakeFromNib(). Moved implementation to layoutSubviews()
        // Presumably, for a lazy implementation, we can have the rating control set here at initialisation, and make it different for the small devices. This works for an iPhone app but might need to change for an iPad app. For now, we'll do a lazy.
        
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = Int(self.bounds.width)
        let minimumWidthForFiveStarDisplay = 358 // this is 90pts for image, 8pts padding either side of rating, and 252 pts for the five star rating control. Probably not excellent practice to just hard-code it, but any assumptions made in calculation of a value here are liable to change if the app design changes so meh, just find this line and update it.
        if width < minimumWidthForFiveStarDisplay && ratingControl.largeInteractiveDisplayMode == true { // since layoutSubviews occurs whenever a cell is added or re-added to the view hierarchy, we test that largeInteractiveDisplayMode is set incorrectly before changing it. This saves us from re-running initialisation code. (ratingControl is lazily constructed tbh, setting largeInteractiveDisplayMode calls setupButtons() which deletes all the button elements and recreates them)
            ratingControl.largeInteractiveDisplayMode = false
        } else if width >= minimumWidthForFiveStarDisplay && ratingControl.largeInteractiveDisplayMode == false { // may as well make it work the other way and make this truly adaptive.
            ratingControl.largeInteractiveDisplayMode = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
