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
        let color = UIColor(red: 59.0/255.0, green: 45.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], forState:.Selected)
        UITabBar.appearance().tintColor = color // UIColor.grayColor()
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*
        var a = self.tabBar.items![0] as! UITabBarItem
        a.title = "hey"
        */
    }

}
