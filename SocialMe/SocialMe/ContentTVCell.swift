//
//  ContentTVCell.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/3/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse

class ContentTVCell: UITableViewCell {

	@IBOutlet weak var specAttrLabel: UILabel!
	@IBOutlet weak var specAttrContentLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var friendPicture: UIImageView!
	
	@IBOutlet weak var expandInfoButton: UIButton!
	
	@IBAction func goToProfile(sender: UIButton) {
		println("Yeah we got it bro")
		var info = [String : Int]()
		info["index"] = friendPicture.tag
		NSNotificationCenter.defaultCenter().postNotificationName("showUserProfile", object: nil, userInfo: info)
	}
	@IBAction func tap(sender: UIButton) {
		var info = [String : Int]()
		info["index"] = sender.tag
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.fromValue = 0.0
		rotateAnimation.toValue = CGFloat(M_PI * 2.0)
		rotateAnimation.duration = 0.2
		sender.layer.addAnimation(rotateAnimation, forKey: nil)
		NSNotificationCenter.defaultCenter().postNotificationName("cellNotification", object: nil, userInfo: info)
		handleTextField()
	}
	
	


	
	func showImg(username: NSString) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			var storedError : NSError!
			var downloadGroup = dispatch_group_create()
			
			dispatch_group_enter(downloadGroup)
			var userQuery = PFUser.query()
			userQuery?.whereKey("username", equalTo: username)
			var userArr = userQuery?.findObjects() as! [PFUser]
			var user = userArr[0]
			
			var profImg : UIImage
			if let userImageFile = user.objectForKey("photo") as? PFFile {
				var imageData = userImageFile.getData() as NSData!
				profImg =  UIImage(data:imageData!)!
			} else {
				profImg = UIImage(named: "swag-60@2x.png")!
			}
			self.friendPicture.image = profImg
			self.friendPicture.contentMode = .ScaleAspectFill
			dispatch_group_leave(downloadGroup)
			dispatch_group_wait(downloadGroup, 5000)
		}
	}
	
    
    func handleTextField() {
        if nameLabel.enabled {
            nameLabel.enabled = false
        } else {
			nameLabel.enabled = true
        }
    }
}
