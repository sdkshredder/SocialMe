//
//  FriendRequestsTVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/23/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse


class FriendRequestsTVC: UITableViewController /* UITableViewDelegate, UITableViewDataSource */ {
	
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
        let cell = tableView.dequeueReusableCellWithIdentifier("friendRequestCell") as! FriendRequectTVCell
		let requestObject = res[indexPath.row] as! PFObject
		let toUsername = requestObject.objectForKey("toUser") as! NSString
		let fromUsername = requestObject.objectForKey("fromUser") as! NSString
		cell.toUsername = toUsername
		cell.fromUsername = fromUsername
		cell.usernameLabel.text = fromUsername as String
		cell.showImg(fromUsername)
        cell.acceptButton.layer.cornerRadius = 4
        cell.acceptButton.layer.borderWidth = 1
        cell.acceptButton.layer.borderColor = UIColor(red: 57.0/255.0, green: 45.0/155.0, blue: 130.0/255.0, alpha: 1).CGColor
		
		cell.acceptButton.tag = indexPath.row
		
        cell.rejectButton.layer.cornerRadius = 4
        cell.rejectButton.layer.borderWidth = 1
        cell.rejectButton.layer.borderColor = UIColor(red: 223.0/255.0, green: 45.0/155.0, blue: 128.0/255.0, alpha: 1).CGColor
        
        cell.blockButton.layer.cornerRadius = 4
        cell.blockButton.layer.borderWidth = 1
        cell.blockButton.layer.borderColor = UIColor.blackColor().CGColor
        cell.profilePicture.tag = indexPath.row
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }

	
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FriendRequestsTVC.showProfile(_:)), name: "showUserProfile", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FriendRequestsTVC.updateTable(_:)), name: "updateRequestTable", object: nil)

		getRequestInfo()
    }
	
	func getRequestInfo() {
		let friendReqQuery = PFQuery(className: "FriendRequests")
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
	
	func updateTable(notification: NSNotification) {
		let info = notification.userInfo as!  [String:Int]
		let index = info["index"]
		print(index)
		var requestToRemove = res[index!] as! PFObject
		let temp = res.mutableCopy() as! NSMutableArray
		temp.removeObjectAtIndex(index!)
		res = temp as NSArray
		
		tableView.reloadData()
	}


    func showProfile(notification: NSNotification) {
        let info = notification.userInfo as! [String : Int]
        let index = info["index"]
        print("index")
		
        let vc = storyboard?.instantiateViewControllerWithIdentifier("profileVC") as! ProfileVC
        
        // Get correct user from index and set username appropriately 
		let requestObject = res[index!] as! PFObject
		vc.username = requestObject["fromUser"] as! NSString
		
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
