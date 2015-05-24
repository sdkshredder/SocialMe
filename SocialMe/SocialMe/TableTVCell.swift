//
//  TableTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/6/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class TableTVCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func editTF(sender: UIButton) {
        if textField.enabled == false {
            UIView.animateWithDuration(0.2, animations: {
                self.textField.enabled = true
                self.textField.text = self.textField.placeholder
                }, completion: {
                    (value: Bool) in
                    self.textField.becomeFirstResponder()
            })
            sender.setTitle("Save", forState: .Normal)
            
        } else {
            var user = PFUser.currentUser()
            var attr = getTitleForPath(sender.tag)
            sender.setTitle("Edit", forState: .Normal)
            UIView.animateWithDuration(0.2, animations: {
                self.textField.enabled = false
            })
            user!.setObject(textField.text, forKey: attr)
            user!.saveInBackgroundWithBlock {
                (succeeded, error) -> Void in
                if error == nil {
                    println("success for user \(user!.username)")
                    
                } else {
                    println("handle error")
                }
            }
        }
    }
    
    
    
    func getTitleForPath(row: Int) -> String {
        var res = ""
        switch row {
        case 0:
            res = "Name"
        case 1:
            res = "Age"
        case 2:
            res = "Hometown"
        case 3:
            res = "School"
        case 4:
            res = "Occupation"
        default:
            res = "hello"
        }
        return res
    }
}
