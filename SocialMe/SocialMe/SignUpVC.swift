//
//  SignUpVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        navigationController?.setNavigationBarHidden(false, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
                constraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            if showsKeyboard == false {
                self.signUpButton.alpha = 1
                self.birthdayLabel.alpha = 1
                self.birthdayPicker.alpha = 1
            }
        }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        //let selectedRange = textView.selectedRange
        //textView.scrollRangeToVisible(selectedRange)
    }
    
    func initTextFields() {
        addTFBorder()
        usernameTF.delegate = self
        passwordTF.delegate = self
        emailTF.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            emailTF.becomeFirstResponder()
        } else {
            emailTF.resignFirstResponder()
        
        }
        return true
    }
    
    
    func addTFBorder() {
        var bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, usernameTF.frame.size.height - 1, usernameTF.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        usernameTF.layer.addSublayer(bottomBorder)
        
        var bottomBorderB = CALayer()
        bottomBorderB.frame = CGRectMake(0.0, passwordTF.frame.size.height - 1, passwordTF.frame.size.width, 1.0);
        bottomBorderB.backgroundColor = UIColor.lightGrayColor().CGColor
        passwordTF.layer.addSublayer(bottomBorderB)
        
        var bottomBorderC = CALayer()
        bottomBorderC.frame = CGRectMake(0.0, emailTF.frame.size.height - 1, emailTF.frame.size.width, 1.0);
        bottomBorderC.backgroundColor = UIColor.lightGrayColor().CGColor
        emailTF.layer.addSublayer(bottomBorderC)
    }

    @IBAction func signUpNewUser(sender: UIButton) {
        var user = PFUser()
        let username = usernameTF.text //as! String
        let lowerCaseUsername = username.lowercaseString
        
        (user.username, user.password, user.email) =
            (lowerCaseUsername, passwordTF.text, emailTF.text)
        
        user.setObject(18, forKey: "lowerAgeFilter")
        user.setObject(41, forKey: "upperAgeFilter")
        user.setObject("both", forKey: "genderFilter")
        user.setObject(10, forKey: "distanceFilter")
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                println("success for user \(user.username)")
                //self.performSegueWithIdentifier("signup", sender: self)
                //self.navigationController?.setNavigationBarHidden(true, animated: true)
                //self.performSegueWithIdentifier("login", sender: self)
            } else {
                let alert = UIAlertView(title: "Error", message: error?.description, delegate: self, cancelButtonTitle: "okay")
                alert.show()
            }
        }
    }
   
}
