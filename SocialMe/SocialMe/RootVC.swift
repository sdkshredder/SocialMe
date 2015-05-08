//
//  RootVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/30/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("main", sender: self)
        } else {
            performSegueWithIdentifier("home", sender: self)
        }

    }
    
}
