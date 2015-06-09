//
//  SwagView.swift
//  SocialMe
//
//  Created by Matt Duhamel on 6/9/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

@IBDesignable
class SwagView : UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.text = PFUser.currentUser()?.username!
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 1
    @IBInspectable var cornerRadius : CGFloat = 1
    @IBInspectable var backgroundButtonColor : UIColor = UIColor.darkGrayColor()
    @IBInspectable var cancelButtonColor : UIColor = UIColor.darkGrayColor()
    @IBInspectable var saveButtonColor : UIColor = UIColor.darkGrayColor()
    @IBInspectable var borderColor : UIColor = UIColor.darkGrayColor()
    
    func setupUsername() {
        
    }
    
    override func awakeFromNib() {
        cancelButton.layer.borderWidth = borderWidth
        cancelButton.layer.borderColor = cancelButtonColor.CGColor
        cancelButton.layer.cornerRadius = cornerRadius
        cancelButton.setTitleColor(cancelButtonColor, forState: .Normal)
        cancelButton.backgroundColor = backgroundButtonColor
        
        button.backgroundColor = backgroundButtonColor
        button.setTitleColor(borderColor, forState: .Normal)
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.CGColor
        button.layer.cornerRadius = cornerRadius
        
        layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1
        
        setupUsername()
    }

    @IBAction func editTouch(sender: UIButton) {
        var title : String
        var color : UIColor
        if sender.titleForState(.Normal) == "Edit" {
            title = "Save"
            textField.enabled = true
            color = saveButtonColor
        } else {
            title = "Edit"
            color = borderColor
            textField.enabled = false
        }
        UIView.animateWithDuration(0.2, animations: {
            sender.setTitle(title, forState: .Normal)
            // sender.layer.borderColor = color.CGColor
            sender.setTitleColor(color, forState: .Normal)
            
        })
    }
    
    @IBAction func cancelTouch(sender: UIButton) {
        UIView.animateWithDuration(0.2, animations: {
            self.removeFromSuperview()
        })
    }
    
}
