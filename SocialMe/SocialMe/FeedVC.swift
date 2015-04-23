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
