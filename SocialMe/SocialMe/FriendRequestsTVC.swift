//
//  FriendRequestsTVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/23/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse


class FriendRequestsTVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
	
	let loggedInUser = PFUser.currentUser()
	var res = NSArray()
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//println("The count is ")
		//print(res.count)
        return res.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell") as! FriendRequectTVCell
		let requestObject = res[indexPath.row] as! PFObject
		let toUsername = requestObject.objectForKey("toUser") as! NSString
		let fromUsername = requestObject.objectForKey("fromUser") as! NSString
		cell.toUsername = toUsername
		cell.fromUsername = fromUsername
		cell.usernameLabel.text = fromUsername as String
		cell.showImg(fromUsername)
        cell.acceptButton.layer.cornerRadius = 4
        cell.acceptButton.layer.borderWidth = 1
        cell.acceptButton.layer.borderColor = UIColor.greenColor().CGColor
		
        cell.rejectButton.layer.cornerRadius = 4
        cell.rejectButton.layer.borderWidth = 1
        cell.rejectButton.layer.borderColor = UIColor.redColor().CGColor
        
        cell.blockButton.layer.cornerRadius = 4
        cell.blockButton.layer.borderWidth = 1
        cell.blockButton.layer.borderColor = UIColor.blackColor().CGColor
        cell.profilePicture.tag = indexPath.row
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }

	
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showProfile:", name: "showUserProfile", object: nil)
		getRequestInfo()
    }
	
	func getRequestInfo() {
		var friendReqQuery = PFQuery(className: "FriendRequests")
		friendReqQuery.whereKey("toUser", equalTo: loggedInUser!.username!)
		friendReqQuery.whereKey("status", equalTo: "pending")
		friendReqQuery.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [PFObject] {
					self.res = objects
					self.tableView.reloadData()
				}
			}
			
		}
	}

    func showProfile(notification: NSNotification) {
        let info = notification.userInfo as! [String : Int]
        let index = info["index"]
        println("index")
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("profileVC") as! ProfileVC
        
        // Get correct user from index and set username appropriately 
		var requestObject = res[index!] as! PFObject
		vc.username = requestObject["fromUser"] as! NSString
		
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
