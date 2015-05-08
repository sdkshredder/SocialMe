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
    
	@IBOutlet weak var userProfPic: UIImageView!
	//@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var profilePic: UIImageView!
    var username = NSString()
	var userPic : UIImage?
	
	let tableView = UITableView()
	var data = NSArray()
	//set width and height by click.....ctrl drag on the center vertically to set it on the blue line
	func tableView(tableView: UITableView, heightForRowAtIndexPath: NSIndexPath) -> CGFloat {
		return 62
	}
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : ProfileTVC = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileTVC
		cell.layoutMargins = UIEdgeInsetsZero
		cell.separatorInset = UIEdgeInsetsZero
		cell.textLabel?.text = "Hi Kelsey"
		
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
		performSegueWithIdentifier("profileSegue", sender: cell)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	
	func initTableView() {
		tableView.frame = view.frame
		tableView.delegate = self
		tableView.dataSource = self
		//view.addSubview(tableView)
	}
	
	func getUserInfo() {
		let value = NSArray()
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
		var res = NSArray()
		//var predicateFormat: String { "username = @self.username"}
		//var attrData:PFQuery = PFQuery(className: "Attributes", predicate: predicateFormat)
			dispatch_async(dispatch_get_main_queue()) {
				self.data = res
				self.tableView.reloadData()
			}
		}
	}
	func drawProfile() {
		profilePic.image = userPic!
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        //let title = UINavigationItem(title: (username as! String))
		//navigationController?.navigationBar.pushNavigationItem(title, animated: true)
		initTableView()
		//getUserInfo()
        // Do any additional setup after loading the view.
		//drawProfile()
    }

	

	

	
	
}