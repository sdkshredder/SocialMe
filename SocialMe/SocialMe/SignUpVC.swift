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
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.initDisplay()
		self.hello()
    }
    
    
    //temp
    func hello() {
        let user = PFUser()
        user.username = "kelsey"
        user.password = "1"
        user.email = "eail@example.com"
        
        // other fields can be set if you want to save more information
        user["phone"] = "650-555-0000"
        /*
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
            } else {
                // Examine the error object and inform the user.
            }
        }
        */
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                // success!
                println("success for user \(user.username)")
                // self.delegate.modalDidFinish(self)
            } else {
                //show error
                println(error)
                /*
                let alertController = UIAlertController(
                    title: "Error",
                    message: error.description,
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                */
                // alertController.addAction(cancelAction)
            }
        }
    }
    
    func initDisplay() {
        let bars = UIImageView(image: UIImage(named: "bg"))
        bars.frame = self.view.frame
        self.view.addSubview(bars)
        self.addNav()
        self.addLogo()
        self.username()
        self.password()
    }
    
    func addNav() {
        let nav = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.width, 66))
        self.view.addSubview(nav)
    }
    
    func addCancel() {
        let cancel = UIButton(frame: CGRectMake(10, 18, 44, 44))
        cancel.backgroundColor = UIColor.yellowColor()
        cancel.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cancel)
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.addCancel()
    }
    
    func addLogo() {
        let logo = UILabel(frame: CGRectMake(self.view.frame.width/2 - 80, 0, 160, 80))
        logo.text = "SocialMe"
        logo.textColor = UIColor.purpleColor()
        logo.font = UIFont(name: "HelveticaNeue-UltraLight", size: 33)
        logo.textAlignment = .Center
        self.view.addSubview(logo)
    }
    
    func username() {
        let username = UITextField(frame: CGRectMake(self.view.center.x - 80, 120, 160, 60))
        username.backgroundColor = UIColor.clearColor()
        username.attributedPlaceholder = NSAttributedString(string: "Usparername", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        username.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        username.textColor = UIColor(red: 255, green: 242, blue: 229, alpha: 1)
        username.delegate = self
        self.view.addSubview(username)
    }
    
    func password() {
        let password = UITextField(frame: CGRectMake(self.view.center.x - 80, 180, 160, 80))
        password.backgroundColor = UIColor.clearColor()
        password.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        password.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        password.textColor = UIColor(red: 255, green: 242, blue: 229, alpha: 1)
        password.delegate = self
        self.view.addSubview(password)
    }
}
