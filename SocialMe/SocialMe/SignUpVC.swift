//
//  SignUpVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTFBorder()
    }
    
    func addTFBorder() {
        var bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, usernameTF.frame.size.height - 1, usernameTF.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.darkGrayColor().CGColor
        usernameTF.layer.addSublayer(bottomBorder)
        
        var bottomBorderB = CALayer()
        bottomBorderB.frame = CGRectMake(0.0, passwordTF.frame.size.height - 1, passwordTF.frame.size.width, 1.0);
        bottomBorderB.backgroundColor = UIColor.darkGrayColor().CGColor
        passwordTF.layer.addSublayer(bottomBorderB)
        
        var bottomBorderC = CALayer()
        bottomBorderC.frame = CGRectMake(0.0, emailTF.frame.size.height - 1, emailTF.frame.size.width, 1.0);
        bottomBorderC.backgroundColor = UIColor.darkGrayColor().CGColor
        emailTF.layer.addSublayer(bottomBorderC)
    }

    @IBAction func signUpNewUser(sender: UIButton) {
        var user = PFUser()
        (user.username, user.password, user.email) =
            (usernameTF.text, passwordTF.text, emailTF.text)
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                println("success for user \(user.username)")
                //self.performSegueWithIdentifier("signup", sender: self)
                
            } else {
                let alert = UIAlertView(title: "Error", message: error?.description, delegate: self, cancelButtonTitle: "okay")
                alert.show()
            }
        }
    }
    
    
    func age() {
        
    }
    
    /*
    
    func addSignUpButton() {
        var frame = CGRectMake(0, 247, self.view.frame.width, 66)
        bg.frame = CGRectMake(0, 247, self.view.frame.width, 0)
        bg.backgroundColor = UIColor.greenColor()
        self.view.addSubview(bg)
        
        formatLabel(frame)
        
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        let listener = UITapGestureRecognizer(target: self, action: "signUpUser:")
        label.addGestureRecognizer(listener)
        self.view.addSubview(label)
        
        UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.bg.frame = frame
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.1, animations: {
                    self.label.alpha = 1
                })
        })
    }
    
    func signUpUser(sender: UITapGestureRecognizer) {
        var user = PFUser()
        (user.username, user.password, user.email) =
            (username.text, password.text, email.text)
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                println("success for user \(user.username)")
                let tabVC : UITabBarController = self.storyboard!
                    .instantiateViewControllerWithIdentifier("tab")
                        as! UITabBarController
                
                self.presentViewController(tabVC,
                    animated: true,
                        completion: nil)
            } else {
                let alert = UIAlertView(title: "Error", message: error?.description, delegate: self, cancelButtonTitle: "okay")
                alert.show()
            }
        }
    }
    
    func setupX(textField : UITextField) {
        var a = (textField.frame.height - 18) / 2
        x.frame = CGRectMake(0, 0, 18, 18)
        x.frame.origin = CGPointMake(textField.frame.width - 18, a)
        x.image = UIImage(named: "x")
        x.alpha = 0
    }
    
    func addX(textField : UITextField) {
        
        setupX(textField)
        textField.addSubview(x)
        
        let rightShake = CGAffineTransformMakeRotation(0.2)
        let leftShake = CGAffineTransformMakeRotation(-0.2)
        let none = CGAffineTransformMakeRotation(0)
        
        UIView.animateWithDuration(0.1, delay: 0, options: nil, animations: {
            self.x.alpha = 1
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.06, delay: 0, options: UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.x.transform = rightShake
                    }, completion: {
                        (value: Bool) in
                        self.x.transform = none
                        UIView.animateWithDuration(0.06, delay: 0, options: UIViewAnimationOptions.Autoreverse  | UIViewAnimationOptions.CurveEaseIn, animations: {
                            self.x.transform = leftShake
                            }, completion: {
                                (value: Bool) in
                                self.x.transform = none
                        })
                })
        })
    
    }
    
    func addCheck(textField : UITextField) {
        
        var a = (textField.frame.height - 34) / 2
        circle.frame = CGRectMake(0, 0, 34, 34)
        circle.frame.origin = CGPointMake(textField.frame.width - 34, a)
        circle.image = UIImage(named: "check-outline")
        circle.alpha = 0.3
        
        var mask = CALayer()
        var w = circle.frame.width * 2
        var o = circle.frame.origin
        
        mask.frame = CGRectMake(-w, w, w, w)
        mask.contents = UIImage(named: "mask")?.CGImage
        
        circle.layer.mask = mask
        textField.addSubview(circle)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = mask.valueForKey("position")
        animation.toValue = NSValue(CGPoint: CGPointMake(w, -w))
        animation.duration = 0.6
        
        check.frame = circle.frame
        check.image = UIImage(named: "check")
        check.alpha = 0
        textField.addSubview(check)
        
        UIView.animateWithDuration(0.8, delay: 0, options: .CurveEaseOut, animations: {
            self.check.alpha = 1
        }, completion: nil)
        
        UIView.animateWithDuration(0.2, delay: 0, options: nil, animations: {
            }, completion: {
                (value: Bool) in
                mask.addAnimation(animation, forKey: "position")
        })
        
    }
    
    func usernameAvailable() {
        if username.text == "" {
            
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            var query = PFUser.query()
            query!.whereKey("username", equalTo:self.username.text)
            var res : NSArray = query!.findObjects()!
            dispatch_async(dispatch_get_main_queue()) {
                if res.count == 0 {
                    self.addCheck(self.username)
                } else {
                    self.addX(self.username)
                }
            }
        }
    }
    
    func removeIndicators(textField: UITextField) {
        UIView.animateWithDuration(0.3, animations: {
            self.circle.alpha = 0
            self.check.alpha = 0
            self.info.alpha = 0
            self.x.alpha = 0
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.placeholder == "Password" {
            usernameAvailable()
            
        } else if textField.placeholder == "Email" {
            if bg.frame.height == 0 {
                addSignUpButton()
            }
        } else {
            removeIndicators(username)
        }
    }

    func removeButton() {
        if (password.text == "" && label.frame.height != 0) {
            UIView.animateWithDuration(0.1, animations: {
                self.label.alpha = 0
                }, completion: {
                    (value: Bool) in
                    UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.bg.frame = CGRectMake(0, self.bg.frame.origin.y, self.view.frame.width, 0)
                    }, completion: nil)
            })
        }
    }
    */
}
