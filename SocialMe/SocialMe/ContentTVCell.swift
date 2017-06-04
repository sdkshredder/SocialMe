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
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
	
	@IBAction func goToProfile(sender: UIButton) {
		print("Yeah we got it bro")
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
		print("The Username is")
		print(username)
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			var storedError : NSError!
			let downloadGroup = dispatch_group_create()
			
			dispatch_group_enter(downloadGroup)
			let userQuery = PFUser.query()
			userQuery?.whereKey("username", equalTo: username)
			var userArr = userQuery?.findObjects() as! [PFUser]
			if (userArr.count > 0 ) {
				let user = userArr[0]
				
				var profImg : UIImage
				if let userImageFile = user.objectForKey("photo") as? PFFile {
					let imageData = userImageFile.getData() as NSData!
					profImg =  UIImage(data:imageData!)!
				} else {
					profImg = UIImage(named: "swag-60@2x.png")!
				}
				self.friendPicture.image = profImg
				self.friendPicture.contentMode = .ScaleAspectFill
				self.friendPicture.layer.cornerRadius = self.friendPicture.frame.height / 2.0
				self.friendPicture.clipsToBounds = true
				self.friendPicture.layer.borderColor = UIColor.darkGrayColor().CGColor
				self.friendPicture.layer.borderWidth = 1
				self.friendPicture.clipsToBounds = true
				
			}
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
