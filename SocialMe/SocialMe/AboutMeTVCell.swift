//
//  AboutMeTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 6/2/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class AboutMeTVCell: UITableViewCell, UITextFieldDelegate {
    
    // @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var aboutMeTF: UITextField!
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    @IBAction func editTouched(sender: UIButton) {
        if sender.titleLabel!.text == "Edit" {
            editButton.setTitle("Save", forState: .Normal)
            aboutMeTF.text = aboutMeLabel.text
            UIView.animateWithDuration(0.2, animations: {
                self.aboutMeTF.alpha = 1
                self.aboutMeLabel.alpha = 0
            })
        }
        
        else {
            editButton.setTitle("Edit", forState: .Normal)
            aboutMeLabel.text = aboutMeTF.text
            saveText()
            UIView.animateWithDuration(0.2, animations: {
                self.aboutMeTF.alpha = 0
                self.aboutMeLabel.alpha = 1
                self.aboutMeTF.resignFirstResponder()
            })
        }
        var info = [String : String]()
        info["value"] = aboutMeTF.text
        NSNotificationCenter.defaultCenter().postNotificationName("aboutMeNotification", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("updateAboutMe", object: nil, userInfo: info)
    }
    
    func saveText() {
        let user = PFUser.currentUser()
        let attr = "aboutMe"
        
        user!.setObject(aboutMeTF.text!, forKey: attr)
        user!.saveInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                print("success saving about me for user \(user!.username)")
            } else {
                print("handle error")
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (range.length + range.location > 300) {
            return false
        }
        return true
    }
}
