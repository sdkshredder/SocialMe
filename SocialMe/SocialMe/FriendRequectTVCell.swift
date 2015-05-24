//
//  FriendRequectTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/23/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit

class FriendRequectTVCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    @IBAction func acceptButtonTouched(sender: UIButton) {
        let alert = UIAlertView(title: "Accept", message: "You have accepted this request", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    @IBAction func RejectButtonTouched(sender: UIButton) {
        let alert = UIAlertView(title: "Reject", message: "You have rejected this request", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    @IBAction func BlockButtonTouched(sender: UIButton) {
        let alert = UIAlertView(title: "Blocked", message: "You have blocked this user", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    @IBAction func profilePictureTouched(sender: UIButton) {
        println(profilePicture.tag)
        
        var info = [String : Int]()
        info["index"] = profilePicture.tag
        NSNotificationCenter.defaultCenter().postNotificationName("showUserProfile", object: nil, userInfo: info)
        
    }
    
}
