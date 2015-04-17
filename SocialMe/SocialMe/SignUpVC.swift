//
//  SignUpVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 4/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initDisplay()
    }

    
    func initDisplay() {
        let label = UILabel(frame: CGRectMake(100, 100, 400, 100))
        label.text = "Hello world"
        label.textColor = UIColor.yellowColor()
        self.view.backgroundColor = UIColor.purpleColor()
        self.view.addSubview(label)
    }
}
