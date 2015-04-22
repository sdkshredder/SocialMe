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
    
    var (username, password) = (UITextField(), UITextField())
    
    let bg = UIView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDisplay()
    }
    
    func addDiv(tf: UITextField) {
        let div = UIView(frame: CGRectMake(0, tf.frame.origin.y + tf.frame.size.height, view.frame.width, 1))
        div.backgroundColor = UIColor.grayColor()
        view.addSubview(div)
    }
    
    func initDisplay() {
        initBGTap()
        addNav()
        addLogo()
        usernameInit()
        passwordInit()
    }
    
    func initBGTap() {
        let bgTap = UIButton(frame: view.frame)
        bgTap.addTarget(self, action: "bgTap:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(bgTap)
    }
    
    func bgTap(sender: UIButton) {
        view.endEditing(true)
    }
    
    func addBackgroundImage() {
        let bars = UIImageView(image: UIImage(named: "bg"))
        bars.frame = view.frame
        view.addSubview(bars)
    }
    
    func addNav() {
        let nav = UINavigationBar(frame: CGRectMake(0, 0, view.frame.width, 64))
        let back = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "back:")
        let item = UINavigationItem()
        item.setLeftBarButtonItem(back, animated: true)
        nav.tintColor = UIColor.grayColor()
        nav.pushNavigationItem(item, animated: true)
        view.addSubview(nav)
    }
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCancel() {
        let cancel = UIButton(frame: CGRectMake(10, 18, 44, 44))
        cancel.backgroundColor = UIColor.yellowColor()
        cancel.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(cancel)
    }
    
    func cancel(sender: UIButton) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.placeholder == "Password") {
            if (bg.frame.height == 0) {
                addSignInButton()
            }
        } else {
            removeButton()
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
    
    func formatLabel(frame: CGRect) {
        label.alpha = 0
        label.frame = frame
        label.text = "LOG IN"
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        label.userInteractionEnabled = true
        label.font = UIFont(name: "HelveticaNeue", size: 18)
    }
    
    
    func addSignInButton() {
        var frame = CGRectMake(0, 187, view.frame.width, 66)
        bg.frame = CGRectMake(0, 187, view.frame.width, 0)
        bg.backgroundColor = UIColor.greenColor()
        view.addSubview(bg)
        
        formatLabel(frame)
        let listener = UITapGestureRecognizer(target: self, action: "logIn:")
        label.addGestureRecognizer(listener)
        view.addSubview(label)
        
        UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.bg.frame = frame
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(0.1, animations: {
                    self.label.alpha = 1
                })
        })
    }
    
    func logIn(sender: UITapGestureRecognizer) {
        PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: {
            (succeeded, error) -> Void in
            if error == nil {
                let tabVC : UITabBarController = self.storyboard!
                    .instantiateViewControllerWithIdentifier("tab")
                        as! UITabBarController
                
                self.presentViewController(tabVC,
                    animated: true, completion: nil)
            } else {
                let alert = UIAlertView(title: "Error", message: "unable to log in", delegate: self, cancelButtonTitle: "okay")
                alert.show()
            }
        })
    }
    
    func addLogo() {
        let logo = UILabel(frame: CGRectMake(view.frame.width/2 - 80, 0, 160, 80))
        logo.text = "SocialMe"
        logo.font = UIFont(name: "HelveticaNeue-Light", size: 33)
        logo.textColor = UIColor.grayColor()
        logo.textAlignment = .Center
        view.addSubview(logo)
    }
    
    func usernameInit() {
        var inset = view.frame.width/10.0
        username.frame = CGRectMake(inset, 66, view.frame.width - inset * 2, 60)
        username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        username.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        username.autocapitalizationType =  .None
        username.delegate = self
        view.addSubview(username)
        addDiv(username)
    }
    
    func passwordInit() {
        var inset = view.frame.width/10.0
        password.frame = CGRectMake(inset, 126, view.frame.width - inset * 2, 60)
        password.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        password.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        password.delegate = self
        password.secureTextEntry = true
        view.addSubview(password)
        addDiv(password)
    }
    
}
