//
//  TBC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/7/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class TBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.purpleColor()], forState:.Selected)
        UITabBar.appearance().tintColor = UIColor.purpleColor()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*
        var a = self.tabBar.items![0] as! UITabBarItem
        a.title = "hey"
        */
    }

}
