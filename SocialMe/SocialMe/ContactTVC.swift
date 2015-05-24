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
    var selected = NSMutableArray()
	var res : NSArray = []
	
	@IBAction func reactToRequest(sender: UIButton) {
		reactToFriendRequest()
	}
	
	func reactToFriendRequest() {
		var requestQuery = PFQuery(className: "FriendRequests")
		requestQuery.whereKey("toUser", equalTo: PFUser.currentUser()!.username!)
		requestQuery.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			if (error == nil) {
				println("Houston we have no problems")
				if let objects = objects as? [PFObject] {
					self.res = objects
					var str = "Hey I love the Los Angeles Lakers"
					self.testResponse(str)
				}
			}
		}
	}
	func testResponse(str :NSString) {
		println(str)
	}
    override func viewDidLoad() {
        super.viewDidLoad()
        table.separatorInset = UIEdgeInsetsZero
        table.layoutMargins = UIEdgeInsetsZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"hello:", name: "cellNotification", object: nil)
    }
    
    func hello(notification: NSNotification) {
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
	
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selected.containsObject(indexPath.row) {
            return 124
        }
        return 62
        
        //selected.containsObject(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("contact") as! ContentTVCell
        cell.button.tag = indexPath.row
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        return cell
    }

}
