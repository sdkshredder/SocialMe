//
//  LoginVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/20/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    let bg = UIView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
        navigationController?.setNavigationBarHidden(false, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func initTextFields() {
        addTFBorder()
        usernameTF.delegate = self
        passwordTF.delegate = self
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
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        // let selectedRange = textView.selectedRange
        // textView.scrollRangeToVisible(selectedRange)
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
    }
    
    @IBAction func displayLoginButton(sender: UITextField) {
        if logInButton.alpha == 0 {
            UIView.animateWithDuration(0.2, animations: {
                self.logInButton.alpha = 1
            })
        }
    }
    
    @IBAction func logIn(sender: UIButton) {
        let username = usernameTF.text
        let lowerCaseUsername = username.lowercaseString
        PFUser.logInWithUsernameInBackground(lowerCaseUsername, password: passwordTF.text, block: {
            (succeeded, error) -> Void in
            if error == nil {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                let alert = UIAlertView(title: "Ops!", message: "unable to log in", delegate: self, cancelButtonTitle: "okay")
                alert.show()
            }
        })
    }
    
    func enableLogInButton() {
        logInButton.enabled = true
        UIView.animateWithDuration(0.2, animations: {
            self.logInButton.backgroundColor = UIColor(red: 0, green: 1, blue: 128/255.0, alpha: 1)
            self.logInButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.logInButton.alpha = 1
        })
    }
    
    // MARK : textField Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == passwordTF {
            if usernameTF.text != "" {
                enableLogInButton()
            }
        } else {
            if passwordTF.text != "" {
                enableLogInButton()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            passwordTF.resignFirstResponder()
        }
        return true
    }
}
