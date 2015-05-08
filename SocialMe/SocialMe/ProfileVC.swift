//
//  ProfileVC.swift
//  SocialMe
//
//  Created by  Kelsey Young on 4/26/15.
//  Copyright (c) 2015 new. All rights reserved.
//

import UIKit
import Parse
import Foundation

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
	@IBOutlet weak var userProfilePic: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	
	var userPic : UIImage?
	var username = "cory"
	var userData = [("Hometown","Los Angeles"),("Occupation","Football"),("School","Stanford University"),("Birthday","1/1/1994")]
	
	//set width and height by click.....ctrl drag on the center vertically to set it on the blue line
	func tableView(tableView: UITableView, heightForRowAtIndexPath: NSIndexPath) -> CGFloat {
		return 62
	}
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileTVC
		let (attr, input)  = userData[indexPath.row]
		cell.layoutMargins = UIEdgeInsetsZero
		cell.separatorInset = UIEdgeInsetsZero
		cell.attrLabel?.text = attr
		//cell.inputLabel?.text = input
		
		//tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
		
		//let user = data[indexPath.row] as! PFUser
		//println(user)
		/*
		cell.textLabel!.text = user.username
		cell.detailTextLabel!.text = user.email
		cell.imageView?.image = UIImage(named: "podcasts")
		cell.separatorInset = UIEdgeInsetsZero
		*/
		// cell.contentView.backgroundColor = UIColor.grayColor()
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// println(indexPath.row)
		//let segueID = UIStoryboardSegue(identifier: "profileSegue", source: self, destination: ProfileVC.self)
		
		let cell = tableView.cellForRowAtIndexPath(indexPath)
	//	performSegueWithIdentifier("profileSegue", sender: cell)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userData.count
	}
	
	
/*
	//TODO: Need to debug for empty resulting array
	func getUserInfo() {
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			var query = PFUser.query()
			query!.whereKey("username", notEqualTo: "blah")
			var res : NSArray = query!.findObjects()!
			dispatch_async(dispatch_get_main_queue()) {
				self.userData = res
				self.tableView.reloadData()
			}
		}
	}
*/

	
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UINavigationItem(title: (self.username as String))
		navigationController?.navigationBar.pushNavigationItem(title, animated: true)
		userProfilePic.image = UIImage(named: "swag-60@2x.png")
		//getUserInfo()
        // Do any additional setup after loading the view.
    }

	

	

	
	
}