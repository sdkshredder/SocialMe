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
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        navigationController?.setNavigationBarHidden(false, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC.handleKeyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpVC.handleKeyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
                self.genderSegmentControl.alpha = 1
            }
        }, completion: nil)
        
        self.signUpButton.enabled = true
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
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, usernameTF.frame.size.height - 1, usernameTF.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        usernameTF.layer.addSublayer(bottomBorder)
        
        let bottomBorderB = CALayer()
        bottomBorderB.frame = CGRectMake(0.0, passwordTF.frame.size.height - 1, passwordTF.frame.size.width, 1.0);
        bottomBorderB.backgroundColor = UIColor.lightGrayColor().CGColor
        passwordTF.layer.addSublayer(bottomBorderB)
        
        let bottomBorderC = CALayer()
        bottomBorderC.frame = CGRectMake(0.0, emailTF.frame.size.height - 1, emailTF.frame.size.width, 1.0);
        bottomBorderC.backgroundColor = UIColor.lightGrayColor().CGColor
        emailTF.layer.addSublayer(bottomBorderC)
    }

    @IBAction func signUpNewUser(sender: UIButton) {
        let user = PFUser()
        let username = usernameTF.text //as! String
        let lowerCaseUsername = username!.lowercaseString
        
        (user.username, user.password, user.email) =
            (lowerCaseUsername, passwordTF.text, emailTF.text)
        
        user.setObject(18, forKey: "lowerAgeFilter")
        user.setObject(50, forKey: "upperAgeFilter")
        user.setObject("Both", forKey: "genderFilter")
        user.setObject(10, forKey: "distanceFilter")
        user.setObject(PFGeoPoint(latitude: 0, longitude: 0), forKey: "location")
        
        let age = getAge()
        if age < 18 {
            let alert = UIAlertView(title: "Ops!", message: "Looks like your too young to use this service.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            user.setObject(age, forKey: "Age")
            
            
            var gender = "Both"
            if genderSegmentControl.selectedSegmentIndex == 0 {
                gender = "Male"
            } else {
                gender = "Female"
            }
            user.setObject(gender, forKey: "gender")
            
            user.signUpInBackgroundWithBlock {
                (succeeded, error) -> Void in
                if error == nil {
                    print("Sign up success for user \(user.username).")
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.performSegueWithIdentifier("signup", sender: self)
                } else {
                    let alert = UIAlertView(title: "Error", message: "Unable to sign you up with the provided information.  It may be that the email you have provided is already in use or is invalid.", delegate: self, cancelButtonTitle: "K whatever")
                    alert.show()
                }
            }
        }
    }
    
    func getAge() -> Int {
       return 100  // TEMP 
        /* NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: birthdayPicker.date, toDate: NSDate(), options: nil).year */
    }

}
