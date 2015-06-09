//
//  AboutMeView.swift
//  SocialMe
//
//  Created by Matt Duhamel on 6/9/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit


class AboutMeView: UIView {

    @IBOutlet weak var title: UILabel! {
        didSet {
            info.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var info: UILabel! {
        didSet {
            info.numberOfLines = 0
        }
    }
    
    @IBAction func tap(sender: UIButton) {
        self.removeFromSuperview()
    }

}
