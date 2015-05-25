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

class ContactTVC: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
	let loggedInUser = PFUser.currentUser()
    var selected = NSMutableArray()
	var data  = NSArray()
    

	
	func retrieveFriends() {
		let value = NSArray()
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			
			
			var query = PFUser.query()
			query!.whereKey("username", equalTo: self.loggedInUser!.username as NSString!)
			query?.includeKey("friends")
			//query!.selectKeys(["friends"])
			var res : NSArray = query!.findObjects()!
			var user : PFUser?
			var userFriends = NSArray()
			if (res.count > 0) {
				user = res[0] as? PFUser
				userFriends = user?.objectForKey("friends") as! NSArray
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
            return 124
        }
        return 62
    }
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("contact") as! ContentTVCell
		if let user = data[indexPath.row] as? PFUser {
			cell.textField.text = user.objectForKey("username") as! String!
		}
		cell.button.tag = indexPath.row
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		table.separatorInset = UIEdgeInsetsZero
		table.layoutMargins = UIEdgeInsetsZero
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"animateCellFrame:", name: "cellNotification", object: nil)
		retrieveFriends()
	}
}
