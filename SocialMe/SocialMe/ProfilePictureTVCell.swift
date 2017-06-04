//
//  ProfilePictureTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/17/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class ProfilePictureTVCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBAction func edit(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("imageNotification", object: nil)
    }
}
