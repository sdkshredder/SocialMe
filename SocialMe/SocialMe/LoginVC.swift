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
    
    let bg = UIView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
    }
    
    func styleButton() {
        logInButton.layer.cornerRadius = logInButton.frame.height/2.0
    }
    
    @IBAction func displayLoginButton(sender: UITextField) {
        if logInButton.alpha == 0 {
            UIView.animateWithDuration(0.2, animations: {
                self.logInButton.alpha = 1
            })
        }
    }
    
    @IBAction func logIn(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(usernameTF.text, password: passwordTF.text, block: {
            (succeeded, error) -> Void in
            if error == nil {
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                let alert = UIAlertView(title: "Error", message: "unable to log in", delegate: self, cancelButtonTitle: "okay")
                alert.show()
            }
        })
    }
}
