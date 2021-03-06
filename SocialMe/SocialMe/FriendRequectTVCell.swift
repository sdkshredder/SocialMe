//
//  FriendRequectTVCell.swift
//  SocialMe
//
//  Created by Kelsey Young on 5/24/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse
import Foundation


class FriendRequectTVCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
	var toUsername : NSString!
	var fromUsername : NSString!
	
	
	func addFriendShip(username :NSString, friendData :PFObject) {
		let query = PFQuery(className: "Friendships")
		query.whereKey("username", equalTo: username)
		var objectArr = query.findObjects() as! [PFObject]
		if objectArr.count > 0 {
			let friendshipObj = objectArr[0]
			if let friendsArr = friendshipObj["friends"] as? NSMutableArray {
				friendsArr.addObject(friendData)
				friendshipObj["friends"] = friendsArr
				friendshipObj.save()
			}
		} else {
			let newFriendship = PFObject(className: "Friendships")
			newFriendship["username"] = username
			let friendsArr = NSMutableArray()
			friendsArr.addObject(friendData)
			newFriendship["friends"] = friendsArr
			newFriendship.save()
		}
	}
	
	func reactToRequest(response :NSString) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			
			var info = [String:Int]()
			info["index"] = self.acceptButton.tag
			
			let toUserQuery = PFUser.query()
			toUserQuery?.whereKey("username", equalTo: self.toUsername)
			var toUserArr = toUserQuery?.findObjects() as! [PFUser]
			let toUser = toUserArr[0]
			
			let fromUserQuery = PFUser.query()
			fromUserQuery?.whereKey("username", equalTo: self.fromUsername)
			var fromUserArr = fromUserQuery?.findObjects() as! [PFUser]
			let fromUser = fromUserArr[0]
			
			let requestQuery = PFQuery(className: "FriendRequests")
			requestQuery.whereKey("toUser", equalTo: toUser.username!)
			requestQuery.whereKey("fromUser", equalTo: fromUser.username!)
			var requestObjectArr = requestQuery.findObjects() as! [PFObject]
			let requestObject = requestObjectArr[0]
			
			if (response == "approved") {
				requestObject["status"] = "approved"
				requestObject.save()
				
				self.addFriendShip(toUser.username!, friendData: fromUser)
				self.addFriendShip(fromUser.username!, friendData: toUser)
/*
				if let var fromUserFriends = fromUser["friends"] as? NSMutableArray {
					fromUserFriends.addObject(toUser)
					fromUser["friends"] = fromUserFriends
				
				} else {
					var friendArr = NSMutableArray()
					friendArr.addObject(toUser)
					fromUser["friends"] = friendArr
				}

				fromUser.save()

				if let var toUserFriends = toUser["friends"] as? NSMutableArray {
					toUserFriends.addObject(fromUser)
					toUser["friends"] = toUserFriends
				} else {
					var friendArr = NSMutableArray()
					friendArr.addObject(fromUser)
					toUser["friends"] = friendArr

				}
				toUser.save()
*/
				
			} else if (response == "rejected") {
				requestObject["status"] = "rejected"
				requestObject.save()
			} else {
				requestObject["status"] = "blocked"
				requestObject.save()
			}
			
			print("toUser is \(toUser.username!)")
			print("fromUser is \(fromUser.username!)")
			

			dispatch_async(dispatch_get_main_queue()) {
				if (response == "approved") {
					let alert = UIAlertView(title: "Accept", message: "You have accepted this request", delegate: nil, cancelButtonTitle: "OK")
					alert.show()
				} else if (response == "rejected") {
					let alert = UIAlertView(title: "Reject", message: "You have rejected this request", delegate: nil, cancelButtonTitle: "OK")
					alert.show()
				} else {
					let alert = UIAlertView(title: "Blocked", message: "You have blocked this user", delegate: nil, cancelButtonTitle: "OK")
					alert.show()
				}
				NSNotificationCenter.defaultCenter().postNotificationName("updateRequestTable", object: nil, userInfo: info)
			}
		}
	}
	
	
	func showImg(username: NSString) {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			var storedError : NSError!
			let downloadGroup = dispatch_group_create()
			
			dispatch_group_enter(downloadGroup)
				let userQuery = PFUser.query()
				userQuery?.whereKey("username", equalTo: username)
				var userArr = userQuery?.findObjects() as! [PFUser]
				let user = userArr[0]
			
				var profImg : UIImage
				if let userImageFile = user.objectForKey("photo") as? PFFile {
					let imageData = userImageFile.getData() as NSData!
					profImg =  UIImage(data:imageData!)!
				} else {
					profImg = UIImage(named: "swag-60@2x.png")!
				}
				self.profilePicture.image = profImg
				self.profilePicture.contentMode = .ScaleAspectFill
			dispatch_group_leave(downloadGroup)
			dispatch_group_wait(downloadGroup, 5000)
		}
	}

	
    @IBAction func acceptButtonTouched(sender: UIButton) {
		reactToRequest("approved")

    }
    
    @IBAction func RejectButtonTouched(sender: UIButton) {

		reactToRequest("rejected")

    }
    
    @IBAction func BlockButtonTouched(sender: UIButton) {

		reactToRequest("blocked")

    }
	
	
    
    @IBAction func profilePictureTouched(sender: UIButton) {
        print(profilePicture.tag)
        
        var info = [String : Int]()
        info["index"] = profilePicture.tag
        NSNotificationCenter.defaultCenter().postNotificationName("showUserProfile", object: nil, userInfo: info)
        
    }
    
}
