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
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        animateBG()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func animateBG() {
        let a = view.frame.height
        let iv = UIImageView(frame: CGRectMake(-a, 0, a, a))
        iv.image = UIImage(named: "line.png")
        backgroundView.addSubview(iv)
        UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            UIView.animateWithDuration(6, animations: {
                iv.frame = CGRectMake(a, 0, a * 5, a * 5)
            })
        }, completion: nil)
    }
    
    @IBAction func logInTouch(sender: UIButton) {
        let loginVC : LoginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as! LoginVC
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func signUpTouch(sender: UIButton) {
        let signupVC : SignUpVC = self.storyboard!.instantiateViewControllerWithIdentifier("signupVC") as! SignUpVC
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func tap(sender: UIButton) {
        animateBG()
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
        login.addTarget(self, action: #selector(HomeVC.login(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        signup.addTarget(self, action: #selector(HomeVC.signup(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        signup.backgroundColor = UIColor.grayColor()
        signup.setTitle("SIGN UP", forState: UIControlState.Normal)
        signup.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(signup)
    }
}
