//
//  ProfileVC.swift
//  SocialMe
//
//  Created by Mariam Ghanbari on 4/26/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    var username = NSString()

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UINavigationItem(title: (username as! String))
    }
}
