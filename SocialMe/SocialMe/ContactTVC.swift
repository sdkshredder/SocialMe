//
//  ContactTVC.swift
//  SocialMe
//
//  Created by Matt Duhamel on 5/3/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse
import Foundation

class ContactTVC: UITableViewController /* , UITableViewDelegate, UITableViewDataSource */ {
    
    @IBOutlet var table: UITableView!
	let loggedInUser = PFUser.currentUser()
    var selected = NSMutableArray()
	var data  = NSArray()
	
	func retrieveFriends() {
		let value = NSArray()
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			
			
			let query = PFQuery(className: "Friendships")
			query.whereKey("username", equalTo: self.loggedInUser!.username as NSString!)
			query.includeKey("friends")
			let res : NSArray = query.findObjects()!
			var userObj : PFObject?
			var userFriends = NSArray()
			if (res.count > 0) {
				userObj = res[0] as? PFObject
				userFriends = userObj?.objectForKey("friends") as! NSArray
			} else {
					print("You have no friends")
			}
			dispatch_async(dispatch_get_main_queue()) {
				self.data = userFriends
				self.tableView.reloadData()
			}
		}
	}
    
    func animateCellFrame(notification: NSNotification) {
        let a = notification.userInfo as! [String : Int]
        let b = a["index"]!
        if selected.containsObject(b) {
            selected.removeObject(b)
        } else {
            selected.addObject(b)
        }
        
        table.beginUpdates()
        table.endUpdates()
        
    }
	
	
    
    @IBAction func showFriendRequests(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("friendRequestTVC") as! FriendRequestsTVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func showMessages(sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("messagesVC") as! MessagesVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selected.containsObject(indexPath.row) {
            return 225
        }
        return 50
    }
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
	
	func capFirstLetter(name: String) -> String {
//		if (name.isEmpty) {
//			return name
//		}
//		var capLet = name.substringWithRange(Range<String.Index>(start: name.startIndex , end: advance(name.startIndex, 1))) as NSString
//		capLet = capLet.uppercaseString
//		let rest =  name.substringFromIndex(advance(name.startIndex, 1)) as NSString
//		return (capLet as String) + (rest as String)
        return "yes"
	}
	
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contact") as! ContentTVCell
		if let user = data[indexPath.row] as? PFUser {
			let username = user.objectForKey("username") as! String!
			let capUsername = capFirstLetter(username)
			cell.nameLabel.text = capUsername
			cell.specAttrLabel.text = "Occupation"
			cell.specAttrContentLabel.text = user.objectForKey("Occupation") as! String!
			cell.expandInfoButton.tag = indexPath.row
			cell.showImg(username)
			cell.friendPicture.tag = indexPath.row
            
		}
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		table.separatorInset = UIEdgeInsetsZero
		table.layoutMargins = UIEdgeInsetsZero
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ContactTVC.animateCellFrame(_:)), name: "cellNotification", object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ContactTVC.showProfile(_:)), name: "showUserProfile", object: nil)
	}
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		retrieveFriends()
	}

	
	func showProfile(notification: NSNotification) {
		let info = notification.userInfo as! [String : Int]
		let index = info["index"]
		print("index")
		
		let vc = storyboard?.instantiateViewControllerWithIdentifier("profileVC") as! ProfileVC

		// Get correct user from index and set username appropriately
		let requestObject = data[index!] as! PFObject
		let profUsername = requestObject["username"] as! NSString
		vc.navigationItem.title = profUsername as String
		vc.username = profUsername
		
		navigationController?.pushViewController(vc, animated: true)
	}

}
