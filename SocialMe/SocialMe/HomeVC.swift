//
//  HomeVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/20/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class HomeVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad();
        styleButtons()
    }
    
    func styleButtons() {
        loginButton.layer.cornerRadius = loginButton.frame.height/2.0
        signupButton.layer.cornerRadius = signupButton.frame.height/2.0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if PFUser.currentUser() != nil {
            /*
            let vc : UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tab") as! UITabBarController
            self.navigationController?.presentViewController(vc, animated: false, completion: nil)
            */
            performSegueWithIdentifier("reveal", sender: self)
        }
    }
    
    @IBAction func logIn(sender: UIButton) {
        let loginVC : LoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as! LoginVC
        navigationController?.pushViewController(loginVC, animated: true)
    }

    
    @IBAction func signUp(sender: UIButton) {
        let signupVC : SignUpVC = self.storyboard!.instantiateViewControllerWithIdentifier("signupVC") as! SignUpVC
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func logo() {
        let logo = UILabel(frame: CGRectMake(view.frame.width/2 - 80, view.frame.height/(1.618 * 2), 160, 80))
        logo.text = "SocialMe"
        logo.textColor = UIColor.grayColor()
        logo.font = UIFont(name: "HelveticaNeue-Light", size: 33)
        logo.textAlignment = .Center
        view.addSubview(logo)
    }
    
    func logIn() {
        let login = UIButton(frame: CGRectMake(0, self.view.frame.height/1.618, self.view.frame.width, 66))
        login.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        login.backgroundColor = UIColor.grayColor()
        login.setTitle("LOG IN", forState: UIControlState.Normal)
        login.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        view.addSubview(login)
    }
    
    func login(sender: UIButton) {
        let loginVC : LoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as! LoginVC
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func signup(sender: UIButton) {
        let signupVC : SignUpVC = self.storyboard!.instantiateViewControllerWithIdentifier("signupVC") as! SignUpVC
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func signUp() {
        let signup = UIButton(frame: CGRectMake(0, view.frame.height/1.618 + 67, view.frame.width, 66))
        signup.addTarget(self, action: "signup:", forControlEvents: UIControlEvents.TouchUpInside)
        signup.backgroundColor = UIColor.grayColor()
        signup.setTitle("SIGN UP", forState: UIControlState.Normal)
        signup.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(signup)
    }
}
