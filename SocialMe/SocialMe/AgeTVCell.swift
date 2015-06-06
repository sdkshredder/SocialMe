//
//  AgeTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/7/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class AgeTVCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editTouched(sender: UIButton) {
        editButton.titleLabel!.text = "Save"
        NSNotificationCenter.defaultCenter().postNotificationName("ageNotification", object: nil)
        handlePicker()
    }
    
    func handlePicker() {
        if datePicker.alpha == 0.0 {
            editButton.setTitle("Save", forState: .Normal)
            UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.datePicker.alpha = 1
                }, completion: nil)
        } else {
            editButton.setTitle("Edit", forState: .Normal)
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.datePicker.alpha = 0
                }, completion: nil)
        }
        
    }
}
