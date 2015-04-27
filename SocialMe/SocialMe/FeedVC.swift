//
//  FeedVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/19/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class FeedVC: UIViewController {
    @IBAction func ShowProfile(sender: UIBarButtonItem) {
        println("Profile Tab")
        navigationController?.setNavigationBarHidden(true, animated: true)
        let tab = tabBarController!.tabBar
        UIView.animateWithDuration(0.2, animations: {
            tab.frame.origin = CGPointMake(0, self.view.frame.height)
            }, completion: {
                (value: Bool) in
                self.addSwipeUp()
        })
        
    }
    
    func addSwipeUp() {
        let swipeView = UIView(frame: CGRectMake(0, view.frame.height - 50, view.frame.width, 50))
        let swipe = UISwipeGestureRecognizer(target: self, action: "swipeUp:")
        swipe.direction = .Up
        
        let tap = UITapGestureRecognizer(target: self, action: "swipeUp:")
        swipeView.userInteractionEnabled = true
        swipeView.addGestureRecognizer(swipe)
        swipeView.addGestureRecognizer(tap)
        view.addSubview(swipeView)
        
    }
    
    func swipeUp(sender: UISwipeGestureRecognizer) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let tab = tabBarController!.tabBar
        UIView.animateWithDuration(0.2, animations: {
            tab.frame.origin = CGPointMake(0, self.view.frame.height - 50)
            }, completion: {
                (value: Bool) in
                sender.view?.removeFromSuperview()
        })
        
    }
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        presentMainVC()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            presentMainVC()
        }
    }
    
    func presentMainVC () {
        let vc : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("nav") as! UINavigationController
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }

}
